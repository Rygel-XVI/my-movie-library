class UserController < ApplicationController

  get '/users/login' do
    if logged_in?
      @user = get_user_by_session
      redirect to "/users/#{@user.id}"
    else
      erb :'/users/login'
    end
  end

  get '/users/signup' do
    if logged_in?
      @user = get_user_by_session
      redirect to "/users/#{@user.slug}"
    else
      erb :'/users/signup'
    end
  end

  get '/users/:id' do
    @user = get_user_by_session
    erb :'users/show'
  end

  post '/users/login' do
    @user = User.find_by(name: params[:name])
    if @user && @user.authenticate(params[:password])
      login(@user)
      redirect to "/users/#{@user.slug}"
    else
      redirect to '/users/login'
    end
  end

  post '/users/signup' do
    if !params[:name].empty? && !params[:email].empty? && !params[:password].empty?
      @user = user.create(params)
      login(@user)
      redirect to "/users/#{@user.slug}"
    else
      redirect to '/'
    end
  end


  ##add patch and delete options for User

end
