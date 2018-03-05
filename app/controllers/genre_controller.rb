class GenreController < ApplicationController

  get '/genres' do
    if logged_in?
      @user = get_user_by_session
      @user_genres = @user.movies.map {|movie| movie.genres}.flatten
      binding.pry
      erb :'/genres/index'
    else
      redirect to '/'
    end
  end

  get '/genres/create_genre' do
    erb :'/genres/create_genre'
  end

  get '/genres/:slug/edit_genre' do
    @genre = Genre.find_by_slug(params[:slug])
    erb :'/genres/edit_genre'
  end

  get '/genres/:slug' do
    @genre = Genre.find_by_slug(params[:slug])
    erb :'/genres/show_genre'
  end

  post '/genres/create_genre' do
    if !params[:name].empty?
      @genre = Genre.create(name: params[:name])
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
