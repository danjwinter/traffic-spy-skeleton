require 'json'
module TrafficSpy
class JsonParser
  attr_reader :user

  def initialize(id)
    @user = TrafficSpy::User.find_by(identifier: id[0..-6]).payloads
  end

  def identifier_data
    {url_popularity: user.url_popularity, browser_popularity: user.browser_popularity, os_popularity: user.os_popularity, resolution_popularity: user.resolution_popularity, response_times: user.avg_response_time}.to_json
  end

end
end