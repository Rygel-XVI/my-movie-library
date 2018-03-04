require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "myhouseiscold"
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    redirect to '/users/signup'
  end

  get '/login' do
    redirect to '/users/login'
  end

  helpers do

    def logged_in?
      !!session[:user_id]
    end

    def login(user)
      session[:user_id] = user.id
    end

    def get_user_by_session
      User.find(session[:user_id])
    end

    def same_user?(user)
      get_user_by_session == user.id
    end

  end
end
