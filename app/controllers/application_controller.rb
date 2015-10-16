class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from Exception, :with => :bad_request
  rescue_from StandardError, :with => :bad_request
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from ActionController::ParameterMissing, :with => :bad_request
  rescue_from ActiveRecord::RecordInvalid, :with => :bad_request
  rescue_from ActiveRecord::RecordNotUnique, :with => :unique_constraint_violation


  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  def handle_options_request
    head(:ok) if request.request_method == 'OPTIONS'
  end

  # For all responses in this controller, return the CORS access control headers.
  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS, PATCH'
    headers['Access-Control-Allow-Headers'] = 'content-type, accept, authorization'
    headers['Access-Control-Max-Age'] = '1728000'
  end

  # If this is a preflight OPTIONS request, then short-circuit the
  # request, return only the necessary headers and return an empty
  # text/plain.
  def cors_preflight_check
    if request.method == :options
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS, PATCH'
      headers['Access-Control-Allow-Headers'] = 'content-type, accept, authorization'
      headers['Access-Control-Max-Age'] = '1728000'
      render :text => '', :content_type => 'text/plain'
    end
  end

  private
  def record_not_found(error)
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS, PATCH'
    headers['Access-Control-Allow-Headers'] = '*'
    headers['Access-Control-Max-Age'] = '1728000'
    render :json => {:error => error.message}, :status => :not_found
  end

  def bad_request(error)
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS, PATCH'
    headers['Access-Control-Allow-Headers'] = '*'
    headers['Access-Control-Max-Age'] = '1728000'
    render :json => {:error => error.message}, :status => :bad_request
  end

  def unique_constraint_violation(error)
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS, PATCH'
    headers['Access-Control-Allow-Headers'] = '*'
    headers['Access-Control-Max-Age'] = '1728000'
    render :json => {:error => error.message}, :status => :conflict
  end


  protected
  def error(params)
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS, PATCH'
    headers['Access-Control-Allow-Headers'] = '*'
    headers['Access-Control-Max-Age'] = '1728000'
    render :json => {:error => params[:message] }, :status => params[:status]
  end

end
