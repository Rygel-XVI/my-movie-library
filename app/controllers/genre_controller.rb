class GenreController < ApplicationController
  use Rack::Flash


  get '/genres' do
    if logged_in?
      @user_genres = get_user_by_session.genres
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
      @genre = get_user_by_session.genres.find_by_slug(params[:slug])
      @user_movies = @user.movies
      erb :'/genres/edit_genre'
    else
      redirect to '/'
    end
  end

  get '/genres/:slug' do
    if logged_in?
      @genre = get_user_by_session.genres.find_by_slug(params[:slug])
      @user_movies = @user.movies.find_all {|movie| movie.genres.include?(@genre)}
      erb :'/genres/show_genre'
    else
      redirect to '/'
    end
  end

  post '/genres/create_genre' do

    if !params[:genre][:name].empty? ##checks for text in text box

      if !get_user_by_session.genres.find_by_slug(slug(params[:genre][:name]))  ##checks if genre already exists
        @genre = Genre.create(name: sanitize_input(params[:genre][:name]))
        @genre.user = @user
        @genre.save

        # checks for checked boxes and then redirects to show page
        if !!params[:genre][:movie_ids]
          @genre.movie_ids = params[:genre][:movie_ids]
        end

        flash[:message] = "#{@genre.name} created."
        redirect to "/genres/#{@genre.slug}"

      else
        flash[:message] = "Genre already exists"
        redirect to "/genres"

      end
    end

    flash[:message] = "No genre name entered"
    redirect to "/genres"
  end

  patch '/genres/:slug/edit_genre' do
    # get genre this edit is associated with
    @genre = get_user_by_session.genres.find_by_slug(params[:slug])

    # if this genre exists that the slug is associated with
    if @genre
      # if the genre slug exists and it matches current genre we are editing then update
      if !@user.genres.find_by_slug(slug(params[:name]))

        if !params[:name].empty?  #if name field isn't empty update
          @genre.update(name: sanitize_input(params[:name]))
        end

        update_movies

        flash[:message] = "Genre Updated"

        ##if the current genre.slug matches a slug owned by the user then update
      elsif @user.genres.find_by_slug(slug(params[:name])).slug == @genre.slug
        @genre.update(name: sanitize_input(params[:name]))

        update_movies

        flash[:message] = "Genre Updated."
      end
      redirect to "/genres/#{@genre.slug}"
    else
    flash[:message] = "Genre does not exists, please create new genre."
    redirect to '/genres/create_genre'
    end
  end

  delete '/genres/:slug/delete_genre' do
      @genre = get_user_by_session.genres.find_by_slug(params[:slug])
      if @genre
        @genre.destroy
        flash[:message] = "#{@genre.name} has been deleted"
      else
          flash[:message] = "Genre does not exist"
      end
      redirect to '/genres'
  end

  helpers do

    def update_movies
      if !!defined?params[:genre][:movie_ids] #if the movie_ids exist then update
        @genre.movie_ids = params[:genre][:movie_ids]
      else
        @genre.movies.clear
        @genre.save
      end
    end

  end

end
