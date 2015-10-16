
module ListingService

  def self.get_land_listing(user_id)
    base_uri=URI.parse(PLOT_LAND_LISTING_SERVICE[:url])
    query_string="?page=1&per_page=3&view=mobile&listed_by=#{user_id}"
    uri=base_uri+query_string
    puts 'Request URL for Plot-Land Listing Service'
    puts "Complete URI #{uri}"

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request["User-Agent"] = PLOT_LAND_LISTING_SERVICE[:user_agent]
    request["Accept"] = PLOT_LAND_LISTING_SERVICE[:accept]

    response = http.request(request)

    listings=JSON.parse(response.body)
    user_details=get_user_details(listing["listing_listed_by"])
    unless listings["active_listings"].nil?
      listings["active_listings"].each do |listing|
        listing["listing_brick_details"]=get_listing_brick_details(listing["listing_id"])
        listing["listing_location_id"]=get_location_details(listing["listing_location_id"])
        listing["boundary_polygon"]=""
        listing["formatted_price_per_unit"]=""
        listing["listing_listed_by"]=user_details
      end
    end
    puts "Complete Listing Info #{listings}"
    return listings
  end

  def self.get_listing_brick_details(listing_id)
    base_uri=URI.parse(BRICK_SERVICE[:url])
    query_string="/projects?listing_id=#{listing_id}"
    uri=base_uri+query_string
    puts 'Request URL for Brick Service'
    puts "Complete URI #{uri}"

    http = Net::HTTP.new(uri.host, uri.port)
    #http.use_ssl = true
    #http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request["User-Agent"] = BRICK_SERVICE[:user_agent]
    request["Accept"] = BRICK_SERVICE[:accept]

    response = http.request(request)

    return (JSON.parse(response.body))
  end

  def self.get_location_details(location_id)
    base_uri=URI.parse(LOCATION_SERVICE[:url])
    query_string="/locations/#{location_id}?fields=name"
    uri=base_uri+query_string
    puts 'Request URL for Location Service'
    puts "Complete URI #{uri}"

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request["User-Agent"] = LOCATION_SERVICE[:user_agent]
    request["Accept"] = LOCATION_SERVICE[:accept]

    response = http.request(request)

    response = JSON.parse(response.body)
    response["boundary_polygon"]=""
    return response
  end

  def self.get_user_details(user_id)
    base_uri=URI.parse(USER_SERVICE[:url])
    query_string="users/#{user_id}"
    uri=base_uri+query_string
    puts 'Request URL for Location Service'
    puts "Complete URI #{uri}"

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request["User-Agent"] = USER_SERVICE[:user_agent]
    request["Accept"] = USER_SERVICE[:accept]
    request["Authorization"] = "bearer "+USER_SERVICE[:auth_token]

    response = http.request(request)
    return (JSON.parse(response.body))
  end

end