class List < ActiveRecord::Base
  include Concerns::FindOrCreateWithJson
  belongs_to :user
end
