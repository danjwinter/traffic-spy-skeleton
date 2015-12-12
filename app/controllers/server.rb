require 'uri'

module TrafficSpy

  class Server < Sinatra::Base

    use Rack::Auth::Basic, "Protected Area" do |username, password|
      if User.exists?(identifier: username) && User.find_by(identifier: username).password == nil
        User.find_by(identifier: username).update(password: password)
      elsif User.exists?(identifier: username)
        password == User.find_by(identifier: username).password
      else
        "Username does not exist. Must register user."
        false
      end
    end
    # 
    # helpers do
    #   def protected!
    #     return if authorized?
    #     headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    #     halt 401, "Not authorized\n"
    #   end
    #
    #   def authorized?
    #     @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    #     # binding.pry
    #     @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [User.find_by(identifier: @auth.credentials[0]), User.find_by(identifier: @auth.credentials[0]).password]
    #   end
    # end

    get '/' do
      # protected!
  erb :index
    end

    not_found do
      erb :error
    end

    get '/sources/:id' do |id|

      if @user = TrafficSpy::User.find_by(identifier: id)
        if @user.payloads.count == 0
          erb :no_payload_data, locals: {id: id}
        else
          erb :application_statistics
        end
      else
        erb :identifier_does_not_exist, locals: {id: id}
      end
    end

    get '/sources/:id/urls/:relative_path' do |id, relative_path|
      @user = TrafficSpy::User.find_by(identifier: id)
      full_path = @user.root_url + '/' + relative_path
      unless @user.payloads.known_url?(full_path)
        erb :unknown_url
      else
        @url_payloads = @user.payloads.where(url: full_path)
        erb :url_data, locals: { relative_path: relative_path }
      end
    end

    post '/sources' do
      TrafficSpy::RegistrationParser.new(params).parsing_validating
    end

    post '/sources/:id/data'  do |id|
      TrafficSpy::PayloadParser.new(params).payload_response
    end

    post '/enter_id' do
      @current_user = params[:name]
      redirect "/sources/#{@current_user}"
    end

  end
end
