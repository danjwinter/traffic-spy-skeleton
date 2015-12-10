module TrafficSpy
  class Payload < ActiveRecord::Base
    # validates :identifier, presence: true, uniqueness: true
    belongs_to :user
    belongs_to :resolution


    def self.url_popularity
      group(:url).count.sort.to_h
    end

    def self.browser_popularity
      group(:user_agent).count.sort.to_h
    end

    def self.os_popularity
      group(:os).count.sort.to_h
    end

    def self.resolution_popularity
      group(:resolution_id).count.sort.to_h
    end

    def self.avg_response_time
      group(:url).average(:responded_in)
    end

    def self.max_response_time
      maximum(:responded_in)
    end

    def self.min_response_time
      minimum(:responded_in)
    end

    def self.average_response_time_per_url
      average(:responded_in)
    end

    def self.http_verbs
      pluck(:request_type).uniq
    end

  end
end
