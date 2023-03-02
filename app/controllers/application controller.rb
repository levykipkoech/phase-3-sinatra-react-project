class ApplicationController < Sinatra::Base
    enable :sessions
    set :session_secret, 'my_secret_key'
  
    def authenticate_user!
      if !current_user
        flash[:error] = "You need to be logged in to access this page."
        redirect '/login'
      end
    end
  
    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  