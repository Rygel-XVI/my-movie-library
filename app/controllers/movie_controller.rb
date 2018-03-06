class MovieController < ApplicationController

  get '/movies' do
    if logged_in?
      @user = get_user_by_session
      @user_movies = @user.movies
      erb :'/movies/index'
    else
      redirect to '/'
    end
  end

  get '/movies/create_movie' do
    erb :'/movies/create_movie'
  end

  get '/movies/:slug/edit_movie' do
    @movie = Movie.find_by_slug(params[:slug])
    erb :'/movies/edit_movie'
  end

  get '/movies/:slug' do
    @movie = Movie.find_by_slug(params[:slug])
    erb :'/movies/show_movie'
  end

  post '/movies/create_movie' do
    if !params[:name].empty?
      @movie = Movie.create(name: params[:name])
    end
    redirect to "/movies/#{@movie.slug}"
  end

  patch '/movies/:slug/edit_movie' do
    @movie = Movie.find_by_slug(params[:slug])
    if !params[:name].empty?
      @movie.update(name: params[:name])
    end
    redirect to "/movies/#{@movie.slug}"
  end

  delete '/movies/:slug/delete' do

  end

end
