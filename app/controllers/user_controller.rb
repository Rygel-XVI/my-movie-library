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
      flash[:message] = "Already logged in, logout to login as another user."
      redirect to "/users/#{@user.slug}"
    else
      erb :'/users/signup'
    end
  end

  get '/users/logout' do
    if logged_in?
      session.clear
      flash[:message] = "Successfully logged out"
      redirect to '/users/login'
    else
      redirect to '/'
    end
  end

  get '/users/:slug/edit' do
    if logged_in? && same_user?(User.find_by_slug(params[:slug]))
      @user = User.find_by_slug(params[:slug])
      erb :'/users/edit'
    else
      redirect to '/'
    end
  end

  get '/users/:slug/delete' do
    if logged_in? && same_user?(User.find_by_slug(params[:slug]))
      @user = User.find_by_slug(params[:slug])
      erb :'/users/delete'
    else
      redirect to '/'
    end
  end

  get '/users/:slug' do
    if logged_in? && same_user?(User.find_by_slug(params[:slug]))
      @user = User.find_by_slug(params[:slug])
      erb :'/users/show'
    else
      redirect to '/'
    end
  end

  post '/users/login' do
    @user = User.find_by(name: params[:name])
    if @user && @user.authenticate(params[:password])
      login(@user)
      flash[:message] = "Login Successful"
      redirect to "/users/#{@user.slug}"
    else
      flash[:message] = "Username or Password incorrect"
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
    @user = User.find_by_slug(params[:slug])

    if @user && same_user?(@user)

      if @user.authenticate(params[:current_pass])

        if !params[:email].empty? && !params[:new_password].empty?
          @user.update(email: params[:email], password: params[:new_password])
          str = "Password and Email updated"

        elsif !params[:email].empty?
          @user.update(email: params[:email])
          str = "Updated email"

        elsif !params[:new_password].empty?
          @user.update(password: params[:new_password])
          str = "Updated password"
        end
        flash[:message] = str
        redirect to "/users/#{@user.slug}"

      else
        flash[:message] = "Wrong password"
        redirect to "/users/#{@user.slug}/edit"
      end

    else
      flash[:message] = "Wrong User"
      redirect to '/users/logout'
    end
  end

  delete '/users/:slug/delete' do
    @user = User.find_by_slug(params[:slug])
    if logged_in? && same_user?(@user) && @user.authenticate(params[:password])
      @user.destroy
      session.clear
      flash[:message] = "User Deleted"
      redirect to '/'
    else
      flash[:message] = "Error deleting user. Please contact admin to resolve."
      redirect to '/'
    end
  end

end
