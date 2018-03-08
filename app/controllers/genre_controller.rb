class GenreController < ApplicationController

  get '/genres' do
    if logged_in?
      @user = get_user_by_session
      @user_genres = @user.movies.map {|movie| movie.genres}.flatten
      erb :'/genres/index'
    else
      redirect to '/'
    end
  end

  get '/genres/create_genre' do
    @user_movies = get_user_by_session.movies
    erb :'/genres/create_genre'
  end

  get '/genres/:slug/edit_genre' do
    @genre = Genre.find_by_slug(params[:slug])
    @user_movies = get_user_by_session.movies
    erb :'/genres/edit_genre'
  end

  get '/genres/:slug' do
    @genre = Genre.find_by_slug(params[:slug])
    @user_movies = get_user_by_session.movies.map do |movie|
      if movie.genres.include?(@genre)
        movie
      end
    end
    erb :'/genres/show_genre'
  end

  post '/genres/create_genre' do
    if !params[:genre][:name].empty?
      @genre = Genre.create(name: params[:genre][:name])
    end
    if !!params[:genre][:movie_ids]
      @genre.movie_ids = params[:genre][:movie_ids]
    end
    redirect to "/genres/#{@genre.slug}"
  end

  patch '/genres/:slug/edit_genre' do
    @genre = Genre.find_by_slug(params[:slug])
    if !params[:name].empty?
      @genre.update(name: params[:name])
    end
    if !!params[:genre][:movie_ids]
      @genre.movie_ids = params[:genre][:movie_ids]
    end
    redirect to "/genres/#{@genre.slug}"
  end

  delete '/genres/:slug/delete' do

  end


end
