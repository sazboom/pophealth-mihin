  Warden::Strategies.add(:basic) do 
    def auth
      @auth ||= Rack::Auth::Basic::Request.new(env)
    end
    
    def store?
      false
    end
 
    def authenticate!
      return custom!(unauthorized) unless auth.provided?
      return custom!(unauthorized) unless auth.basic?
      user = User.where(:username => auth.credentials.first).first
      if user and user.valid_password?(auth.credentials[1])
        return success!(user)
      else
        return custom!(unauthorized :invalid_key)
      end
    end
      
 
    def unauthorized(type = nil)
      type ||= :bad_request
      key = auth.provided? ? auth.credentials.first : ''
      
      error_messages = {
        bad_request: "You did not provide an API key. ", 
        invalid_key: "Invalid API Key provided: #{key}"
      }
 
      error_response = {
        error: {
          message: error_messages[type],
          type: "invalid_request_error"
        }
      }
      Rack::Response.new([JSON.pretty_generate(error_response)], 401, 'Content-Type' => 'application/json', 'WWW-Authenticate' => %(Basic realm="API") )
    end
    
  end

