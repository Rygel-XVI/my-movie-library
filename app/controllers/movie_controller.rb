class MovieController < ApplicationController

  get '/movies' do
    if logged_in?
      get_user_by_session
      @user_movies = @user.movies
      erb :'/movies/index'
    else
      redirect to '/'
    end
  end

  get '/movies/create_movie' do
    if logged_in?
      @user_genres = get_user_by_session.genres
      erb :'/movies/create_movie'
    else
      redirect to '/'
    end
  end

  get '/movies/:slug/edit_movie' do
    if logged_in?
      @movie = get_user_by_session.movies.find_by_slug(params[:slug])
      @user_genres = @user.genres
      erb :'/movies/edit_movie'
    else
      redirect to '/'
    end
  end

  get '/movies/:slug' do
    if logged_in?
      @movie = get_user_by_session.movies.find_by_slug(params[:slug])
      erb :'/movies/show_movie'
    else
      redirect to '/'
    end
  end

  post '/movies/create_movie' do
    if !params[:movie][:name].empty?

      # sanitized = sanitize_input(params[:movie][:name])

      if !get_user_by_session.movies.find_by_slug(slug(params[:movie][:name]))
        @movie = Movie.create(name: sanitize_input(params[:movie][:name]))
        @movie.user = @user
        str = "#{@movie.name} Created."

        # associates checked genres to the movie
        if !!params[:movie][:genre_ids]
          @movie.genre_ids = params[:movie][:genre_ids]
        end

        # if user wants to make a new genre this creates a new genre and associates it with the current user and movie
        if !params[:genre][:name].empty? && !@user.genres.find_by_slug(slug(params[:genre][:name]))

          @genre = Genre.create(name: sanitize_input(params[:genre][:name]))
          @movie.genres << @genre
          @genre.user = @user
          @genre.save

          str = str + " #{@genre.name} Created."
        else
          str = str + " New genre not created."
        end

        @movie.save
        flash[:message] = str
        redirect to "/movies/#{@movie.slug}"
      else
        flash[:message] = "#{sanitize_input(params[:movie][:name])} already exists."
        redirect to '/movies'
      end
    end
    flash[:message] = "No text entered"
    redirect to '/movies'
  end

  patch '/movies/:slug/edit_movie' do
    @movie = get_user_by_session.movies.find_by_slug(params[:slug])

    # checks that movie is owned by the user
    if @movie
      str = ""
      if !params[:name].empty?
        @movie.update(name: sanitize_input(params[:name]))
        str = "#{@movie.name} Updated."
      end

      if !!defined?params[:movie][:genre_ids]
        @movie.genre_ids = params[:movie][:genre_ids]
      end
binding.pry
      if !params[:genre][:name].empty? && !get_user_by_session.genres.find_by_slug(slug(params[:genre][:name]))

        @genre = Genre.create(name: sanitize_input(params[:genre][:name]))
        @movie.genres << @genre
        @genre.user = @user
        @genre.save

        str = str + " #{@genre.name} Created."

      elsif !params[:genre][:name].empty? && get_user_by_session.genres.find_by_slug(slug(params[:genre][:name]))
        str = str + " Genre already exists."
      end

      flash[:message] = str
      redirect to "/movies/#{@movie.slug}"
    else

      flash[:message] = "Update failed"
      redirect to "/movies"
    end
  end

  delete '/movies/:slug/delete_movie' do
      @movie = get_user_by_session.movies.find_by_slug(params[:slug])
      if @movie
        @movie.destroy
        flash[:message] = "#{@movie.name} has been deleted"
      else
          flash[:message] = "Movie does not exist"
      end
      redirect to '/movies'
  end

end
