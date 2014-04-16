class User < ActiveRecord::Base
  include Concerns::FindOrCreateWithJson
end
