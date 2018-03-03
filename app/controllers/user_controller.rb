class UserController < ApplicationController

  get '/users/login' do
    erb :'/users/login'
  end

  get '/users/signup' do
    erb :'/users/signup'
  end

  get '/users/show' do
    erb :'users/show'
  end

  post '/users/login' do

    binding.pry
  end

  post '/users/signup' do
    binding.pry
    if !logged_in?
      @user = user.create(params)
      login(@user)
    end
    redirect to "/users/show"
  end

end
