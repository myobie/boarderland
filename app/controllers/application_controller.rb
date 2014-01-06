class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def require_access_token
    unless session[:access_token]
      redirect_to authorize_wunderlist_path
    end
  end

  def wunderlist
    Wunderlist.new(session[:access_token])
  end
end
