class Task < ActiveRecord::Base
  include Concerns::FindOrCreateWithJson
end
