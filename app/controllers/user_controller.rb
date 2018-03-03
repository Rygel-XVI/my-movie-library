class UserController < ApplicationController

  get '/users/login' do
    if logged_in?
      redirect to '/users/show'
    end
    erb :'/users/login'
  end

  get '/users/signup' do
    if logged_in?
      redirect to '/users/show'
    end
    erb :'/users/signup'
  end

  get '/users/show' do
    erb :'users/show'
  end

  post '/users/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
  end

  post '/users/signup' do
    @user = user.create(params)
    login(@user)
    redirect to "/users/show"
  end

end
