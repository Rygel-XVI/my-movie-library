class GenreController < ApplicationController

  get '/genres' do
    if logged_in?
      erb :'/genres/index'
    else
      redirect to '/'
    end
  end

  get '/genres/create' do
    erb :'/genres/create_genre'
  end

  get '/genres/:slug/edit' do
    @genre = Genre.find_by_slug(params[:slug])
    erb :'/genres/edit_genre'
  end

  get '/genres/:slug' do
    @genre = Genre.find_by_slug(params[:slug])
    erb :'/genres/show_genre'
  end

  post '/genres/create' do
    if !params[:name].empty?
      @genre = Genre.create(name: params[:name])
    end
    redirect to "/genres/#{@genre.slug}"
  end

  patch '/genres/:slug/edit' do
    @genre = Genre.find_by_slug(params[:slug])
    if !params[:name].empty?
      @genre.update(name: params[:name])
    end
    redirect to "/genres/#{@genre.slug}"
  end

  delete '/genres/:slug/delete' do

  end


end
