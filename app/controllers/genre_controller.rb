class GenreController < ApplicationController

  get '/genres' do
    if logged_in?
      erb :'/genres/index'
    else
      redirect to '/'
    end
  end

  get '/genres/create' do
    goes to create page
  end

  get '/genres/:slug/edit' do
    goes to edit page
  end

  get '/genres/:slug' do
    goes to show page
  end

  post '/genres/create' do

  end

  patch '/genres/:slug/edit' do

  end

  delete '/genres/:slug/delete' do
    
  end


end
