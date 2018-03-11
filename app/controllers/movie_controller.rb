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
    if logged_in?
      @user_genres = get_user_by_session.genres.uniq
      erb :'/movies/create_movie'
    else
      redirect to '/'
    end
  end

  get '/movies/:slug/edit_movie' do
    if logged_in?
      @movie = Movie.find_by_slug(params[:slug])
      @user_genres = get_user_by_session.genres.uniq
      erb :'/movies/edit_movie'
    else
      redirect to '/'
    end
  end

  get '/movies/:slug' do
    if logged_in?
      @movie = Movie.find_by_slug(params[:slug])
      @user = get_user_by_session
      erb :'/movies/show_movie'
    else
      redirect to '/'
    end
  end

  post '/movies/create_movie' do

    if !params[:movie][:name].empty? && !Movie.find_by(name: sanitize_input(params[:movie][:name]))
      sanitized_movie = sanitize_input(params[:movie][:name])
      @movie = Movie.create(name: sanitized_movie)
      @movie.user = get_user_by_session

# associates existing genres to the movie
      if !!params[:movie][:genre_ids]
        @movie.genre_ids = params[:movie][:genre_ids]
      end

# if user wants to make a new genre this creates a new genre and associates it with the current user and movie
      if !params[:genre][:name].empty? && !Genre.find_by(name: sanitize_input(params[:genre][:name]))
        sanitized_genre = sanitize_input(params[:genre][:name])

        @genre = Genre.create(name: sanitized_genre)
        @movie.genres << @genre
        @genre.user = get_user_by_session
        @genre.save
      end

      @movie.save
      redirect to "/movies/#{@movie.slug}"
    else
      redirect to '/movies'
    end
  end

  patch '/movies/:slug/edit_movie' do
    @movie = Movie.find_by_slug(params[:slug])

    if !params[:name].empty?
      @movie.update(name: sanitize_input(params[:name]))
    end

    if !!defined?params[:movie][:genre_ids]
      @movie.genre_ids = params[:movie][:genre_ids]
    end

    if !params[:genre][:name].empty?
      @genre = Genre.create(name: sanitize_input(params[:genre][:name]))
      @movie.genres << @genre
      @genre.user = get_user_by_session
      @genre.save
    end

    flash[:message] = "#{@movie.name} Updated"
    redirect to "/movies/#{@movie.slug}"
  end

  delete '/movies/:slug/delete_movie' do
      @movie = Movie.find_by_slug(params[:slug])
      flash[:message] = "#{@movie.name} has been deleted"
      @movie.destroy
      redirect to '/movies'
  end

end
