require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Boarderland
  class Application < Rails::Application
    config.generators do |g|
      g.helper false
      g.assets false
    end
    config.cache_store = :dalli_store
  end
end
