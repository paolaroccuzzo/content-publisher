# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'development#index'
  get '/form' => 'development#form'

  get "/healthcheck", to: proc { [200, {}, ["OK"]] }
end
