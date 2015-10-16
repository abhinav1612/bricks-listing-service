
class ListingsController < ApplicationController

  include ListingService

  # GET /listings?user_id
  def listing_compete_details
    result = ListingService.get_land_listing(params[:user_id])
    render json: result
  end

end
