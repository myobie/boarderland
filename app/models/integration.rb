class Integration < ActiveRecord::Base
  def user
    User.find_by(wunderlist_id: wunderlist_user_id) if wunderlist_user_id
  end
end
