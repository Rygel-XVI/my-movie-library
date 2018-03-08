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
    @user_genres = get_user_by_session.genres
    erb :'/movies/create_movie'
  end

  get '/movies/:slug/edit_movie' do
    @movie = Movie.find_by_slug(params[:slug])
    @user_genres = get_user_by_session.genres
    erb :'/movies/edit_movie'
  end

  get '/movies/:slug' do
    @movie = Movie.find_by_slug(params[:slug])
    erb :'/movies/show_movie'
  end

  post '/movies/create_movie' do
    if !params[:movie][:name].empty?
      @movie = Movie.create(name: params[:movie][:name])
      @movie.genre_ids = params[:movie][:genre_ids]
      get_user_by_session.movies << @movie
      redirect to "/movies/#{@movie.slug}"
    else
      redirect to '/movies'
    end
  end

  patch '/movies/:slug/edit_movie' do
    @movie = Movie.find_by_slug(params[:slug])
    if !params[:name].empty?
      @movie.update(name: params[:name])
    end
    if !!params[:movie][:genre_ids]
      @movie.genre_ids = params[:movie][:genre_ids]
    end
    redirect to "/movies/#{@movie.slug}"
  end

  delete '/movies/:slug/delete' do

  end

end
