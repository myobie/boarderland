class Wunderlist
  def self.config
    @config ||= Mashed::Mash.new({
      client_id: nil,
      client_secret: nil,
      base_url: "https://a.wunderlist.com/api",
      authorize_url: "https://provider.wunderlist.com/login/oauth/authorize",
      access_token_url: "https://provider.wunderlist.com/login/oauth/access_token"
    })
  end

  def self.authorize_url
    "#{config.authorize_url}?client_id=#{config.client_id}"
  end

  def self.access_token(code)
    response = Typhoeus.post(config.access_token_url, headers: {
      "Accept" => "application/json",
      "Content-Type" => "application/json"
    }, body: JSON.generate({
      client_id: config.client_id,
      client_secret: config.client_secret,
      code: code
    }))

    if response.success?
      json = JSON.parse response.body
      json["access_token"]
    end
  end

  def initialize(access_token)
    @access_token = access_token
  end

  def get(path, params = {})
    path = "/#{path.gsub(/^\//, '')}"
    url = "#{config.base_url}#{path}"
    cache_key = [:v1, :wunderlist, :api, :request, :get, url, params.hash].join(":")
    expires = 7.minutes + rand(3).minutes
    json = Rails.cache.fetch(cache_key, expires_in: expires) do
      response = Typhoeus.get(url, params: params, headers: headers)
      if response.success?
        JSON.parse response.body
      end
    end

    if json.is_a?(Array)
      json.map! { |j| Mashed::Mash.new(j) }
    elsif json.is_a?(Hash)
      Mashed::Mash.new j
    else
      j
    end
  end

  private

  attr_reader :access_token

  def config
    self.class.config
  end

  def headers
    {
      "X-Access-Token" => access_token,
      "X-Client-ID" => config.client_id,
      "Accept" => "application/json",
      "Content-Type" => "application/json"
    }
  end
end
