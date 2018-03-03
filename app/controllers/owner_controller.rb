class OwnerController < ApplicationController

  get '/owners/login' do
    erb :'/owners/login'
  end

  get '/owners/signup' do
    erb :'/owners/signup'
  end

  post '/owners/login' do
    binding.pry
  end

  post '/owners/signup' do
    binding.pry
  end

end
