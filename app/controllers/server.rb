module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    not_found do
      erb :error
    end

    post '/sources' do
      if params[:identifier] && params[:rootUrl]
        user = User.new(identifier: params[:identifier], root_url: params[:rootUrl])
        if user.save
          id = params[:identifier]
          {'identifier': id}.to_json
        else
          status(403)
          "Identifier already exists."
        end
      else
        status(400)
        "Missing all required details."
      end
    end

    post '/sources/:id/data'  do |id|
      # binding.pry
      p_pams = JSON.parse(params["payload"])
      p_sha = Digest::SHA1.hexdigest(p_pams.to_s)
      if Payload.find_by(payload_sha: p_sha)
        status 403
        body "This specific payload already exists in the database..."
      else
        identifier = params["id"]
        user_id = User.find_by(identifier: identifier).id
        ua = UserAgent.parse(p_pams[:UserAgent])
        resolution = Resolution.find_or_create_by(dimension: "#{p_pams["resolutionWidth"]} x #{p_pams["resolutionHeight"]}")
        Payload.create(user_id: user_id, resolution_id: resolution.id, url: p_pams["url"], requested_at: p_pams["requestedAt"], responded_in: p_pams["respondedIn"], referred_by: p_pams["referredBy"], request_type: p_pams["requestType"], parameters: p_pams["parameters"], event_name: p_pams["eventName"], user_agent: ua, ip: p_pams["ip"],  payload_sha: p_sha)
      end
    end
  end
end
