class UserController < ApplicationController

  get '/users/login' do
    if logged_in?
      @user = get_user_by_session
      redirect to "/users/#{@user.slug}"
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

  get '/users/logout' do
    if logged_in?
      session.clear
      redirect to '/users/login'
    else
      redirect to '/'
    end
  end

  get '/users/:slug/edit' do
    @user = User.find_by_slug(params[:slug])
    erb :'/users/edit'
  end

  get '/users/:slug/delete' do
    @user = User.find_by_slug(params[:slug])
    erb :'/users/delete'
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'/users/show'
  end

  post '/users/login' do
    @user = User.find_by(name: params[:name])
    if @user && @user.authenticate(params[:password])
      binding.pry
      login(@user)
      redirect to "/users/#{@user.slug}"
    else
      redirect to '/users/login'
    end
  end

  post '/users/signup' do
    if !params[:name].empty? && !params[:email].empty? && !params[:password].empty?
      @user = User.create(params)
      login(@user)
      redirect to "/users/#{@user.slug}"
    else
      redirect to '/'
    end
  end

  patch '/users/:slug/edit' do
    if !params[:email].empty? || !params[:password].empty?
      #add flash messages
      @user = User.find_by_slug(params[:slug])
      @user.update(email: params[:email]) if !params[:email].empty?
      @user.update(password: params[:password]) if !params[:password].empty?
    end
    redirect to "/users/#{@user.slug}"
  end

  delete '/users/:slug/delete' do
    binding.pry
    @user = User.find_by_slug(params[:slug])
    if logged_in? && same_user?(@user)
      #add a success flash message
      @user.destroy
      session.clear
    end
      redirect to '/'
  end

end
