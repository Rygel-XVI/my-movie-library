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
    @user = get_user_by_session
    @gid = @user.genre_ids.map {|genre_id| Genre.find(genre_id)} ##list of genres owned by user
    erb :'/genres/create_genre'
  end

  get '/genres/:slug/edit_genre' do
    @genre = Genre.find_by_slug(params[:slug])
    erb :'/genres/edit_genre'
  end

  get '/genres/:slug' do
    @genre = Genre.find_by_slug(params[:slug])
    @user = get_user_by_session
    @user_movies = @user.movies.map do |movie|
      if movie.genre_ids.include?(@genre.id)
        movie
      end
    end
    erb :'/genres/show_genre'
  end

  post '/genres/create_genre' do
    if !params[:genre][:name].empty?
      binding.pry
      @genre = Genre.create(name: params[:genre][:name])
    end
    redirect to "/genres/#{@genre.slug}"
  end

  patch '/genres/:slug/edit_genre' do
    @genre = Genre.find_by_slug(params[:slug])
    if !params[:name].empty?
      @genre.update(name: params[:name])
    end
    redirect to "/genres/#{@genre.slug}"
  end

  delete '/genres/:slug/delete' do

  end


end
