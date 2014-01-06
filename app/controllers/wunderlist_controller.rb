class WunderlistController < ApplicationController
  def authorize
    redirect_to Wunderlist.authorize_url
  end

  def callback
    code = params[:code]
    access_token = Wunderlist.access_token(code)
    session[:access_token] = access_token
    redirect_to root_path
  end
end
