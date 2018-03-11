class GenreController < ApplicationController
  use Rack::Flash


  get '/genres' do
    if logged_in?
      @user = get_user_by_session
      @user_genres = @user.genres
      erb :'/genres/index'
    else
      redirect to '/'
    end
  end

  get '/genres/create_genre' do
    if logged_in?
      @user_movies = get_user_by_session.movies
      erb :'/genres/create_genre'
    else
      redirect to '/'
    end
  end

  get '/genres/:slug/edit_genre' do
    if logged_in?
      @genre = Genre.find_by_slug(params[:slug])
      @user_movies = get_user_by_session.movies
      erb :'/genres/edit_genre'
    else
      redirect to '/'
    end
  end

  get '/genres/:slug' do
    if logged_in?
      @genre = Genre.find_by_slug(params[:slug])
      @user_movies = get_user_by_session.movies.find_all {|movie| movie.genres.include?(@genre)}
      erb :'/genres/show_genre'
    else
      redirect to '/'
    end
  end

  post '/genres/create_genre' do

    if !params[:genre][:name].empty? ##checks for text in text box

      sanitized = sanitize_input(params[:genre][:name])

      if !Genre.find_by(name: sanitized)  ##checks if genre already exists
        @genre = Genre.create(name: sanitized)
        @genre.user = get_user_by_session
        @genre.save

        # checks for checked boxes and then redirects to show page
        if !!params[:genre][:movie_ids]
          @genre.movie_ids = params[:genre][:movie_ids]
        end

        flash[:message] = "#{sanitized} created."
        redirect to "/genres/#{@genre.slug}"

      else
        flash[:message] = "#{sanitized} already exists"
        redirect to "/genres"

      end
    end

    flash[:message] = "No genre name entered"
    redirect to "/genres"
  end

  patch '/genres/:slug/edit_genre' do
    @genre = Genre.find_by_slug(params[:slug])
    sanitized = sanitize_input(params[:name])

    if !Genre.find_by(name: sanitized)

      if !params[:name].empty?
        @genre.update(name: sanitized)
      end

      if !!defined?params[:genre][:movie_ids]
        @genre.movie_ids = params[:genre][:movie_ids]
      end

      flash[:message] = "Genre Updated"
    else
      flash[:message] = "Genre not updated. Contact admin if problem persists."
    end

    redirect to "/genres/#{@genre.slug}"
  end

  delete '/genres/:slug/delete_genre' do
      @genre = Genre.find_by_slug(params[:slug])
      @genre.destroy
      flash[:message] = "#{@genre.name} has been deleted"
      redirect to '/genres'
  end

end
