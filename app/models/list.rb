class List < ActiveRecord::Base
  include Concerns::FindOrCreateWithJson
end
