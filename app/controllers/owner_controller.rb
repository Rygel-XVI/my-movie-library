class OwnerController < ApplicationController

  get '/owners/login' do
    erb :'/owners/login'
  end

  get '/owners/signup' do
    erb :'/owners/signup'
  end

  get '/owners/show' do
    erb :'owners/show'
  end

  post '/owners/login' do

    binding.pry
  end

  post '/owners/signup' do
    if !logged_in?
      @owner = Owner.create(params)
      login(@owner)
    end
    redirect to "/owners/show"
  end

end
