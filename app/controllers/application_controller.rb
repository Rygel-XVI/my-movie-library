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
    redirect to '/owners/signup'
  end

  get '/login' do
    binding.pry
    redirect to 'owners/login'
  end
end
