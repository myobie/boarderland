class Wunderlist
  def self.config
    @config ||= Mashed::Mash.new({
      client_id: nil,
      client_secret: nil,
      base_url: "https://a.wunderlist.com/api"
    })
  end

  def initialize(access_token)
    @access_token = access_token
  end

  def get(path, params = {})
    path = "/#{path.gsub(/^\//, '')}"
    url = "#{config.base_url}#{path}"
    response = Typhoeus.get(url, params: params, headers: headers)
    if response.success?
      json = JSON.parse response.body
      if json.is_a?(Array)
        json.map! { |j| Mashed::Mash.new(j) }
      elsif json.is_a?(Hash)
        Mashed::Mashed.new j
      else
        j
      end
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
      "X-Client-ID" => config.client_id
    }
  end
end
