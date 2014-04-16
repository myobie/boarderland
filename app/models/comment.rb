class Comment < ActiveRecord::Base
  include Concerns::FindOrCreateWithJson
end
