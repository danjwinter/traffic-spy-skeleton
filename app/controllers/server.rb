module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    not_found do
      erb :error
    end

    get '/sources/:id' do |id|
      @id = id
      erb :application_statistics
    end


    post '/sources' do
      TrafficSpy::RegistrationParser.new(params).parsing_validating
    end

    post '/sources/:id/data'  do |id|
      TrafficSpy::PayloadParser.new(params).payload_response
    end
  end
end
