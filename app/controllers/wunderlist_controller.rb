class WunderlistController < ApplicationController
  def authorize
    redirect_to Wunderlist.authorize_url
  end

  def callback
    code = params[:code]

    access_token = Wunderlist.access_token(code)
    session[:access_token] = access_token

    integration = Integration.find_or_create_by(access_token: access_token)
    user_info = wunderlist.get("v1/user")
    user = User.find_or_create_by_json(user_info)
    integration.update(wunderlist_user_id: user.wunderlist_id)

    redirect_to root_path
  end
end
