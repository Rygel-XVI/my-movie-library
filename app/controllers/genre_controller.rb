class GenreController < ApplicationController
  use Rack::Flash


  get '/genres' do
    if logged_in?
      @user = get_user_by_session
      @user_genres = @user.genres.uniq
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
    @user_movies = get_user_by_session.movies.find_all {|movie| movie.genres.include?(@genre)}
    erb :'/genres/show_genre'
  end

  post '/genres/create_genre' do
    if !params[:genre][:name].empty? ##checks for text in text box

      if !Genre.find_by(name: params[:genre][:name])  ##checks if genre already exists
        @genre = Genre.create(name: params[:genre][:name])

        # checks for checked boxes and then redirects to show page
        if !!params[:genre][:movie_ids]
          @genre.movie_ids = params[:genre][:movie_ids]
        end
        flash[:message] = "#{params[:genre][:name]} created."
        redirect to "/genres/#{@genre.slug}"

      else
        flash[:message] = "#{params[:genre][:name]} already exists"
        redirect to "/genres"

      end
    end

    flash[:message] = "No genre name entered"
    redirect to "/genres"
  end

# add flash messages
  patch '/genres/:slug/edit_genre' do
    @genre = Genre.find_by_slug(params[:slug])
    if !Genre.find_by(name: params[:name])
      if !params[:name].empty?
        @genre.update(name: params[:name])
      end
      if !!params[:genre][:movie_ids]
        @genre.movie_ids = params[:genre][:movie_ids]
      end
    else
      # message already exists
    end

    redirect to "/genres/#{@genre.slug}"
  end

  delete '/genres/:slug/delete' do
    #no deleting by the user, too complicated. they should contact the program admin to do this
    #unused genres would have to get deleted intermittently
  end


end
