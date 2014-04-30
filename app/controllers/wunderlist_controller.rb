class WunderlistController < ApplicationController
  skip_before_filter :require_access_token

  def authorize
    redirect_to Wunderlist.authorize_url
  end

  def callback
    code = params[:code]

    access_token = Wunderlist.access_token(code)

    if access_token
      session[:access_token] = access_token

      integration = Integration.find_or_create_by(access_token: access_token)
      user_info = wunderlist.get("v1/user")

      if user_info
        user = User.find_or_create_with_json(user_info)
        integration.update(wunderlist_user_id: user.wunderlist_id)
      else
        session.clear
        render text: "uh", status: 500
        return
      end

      redirect_to root_path
    else
      render text: "whoops", status: 500
    end
  end
end
