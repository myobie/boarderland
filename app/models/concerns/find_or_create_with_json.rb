module Concerns::FindOrCreateWithJson
  extend ActiveSupport::Concern

  module ClassMethods
    def find_or_create_with_json(json)
      model = find_or_create(wunderlist_id: json["id"])
      model.update(data: json)
      model
    end
  end
end
