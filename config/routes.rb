Rails.application.routes.draw do

  get 'listings' => 'listings#complete_amenities'

end
