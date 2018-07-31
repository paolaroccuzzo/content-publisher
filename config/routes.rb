# frozen_string_literal: true

Rails.application.routes.draw do
  root to: redirect('/documents')
  get '/dev' => 'development#index'

  get '/documents/publishing-guidance' => 'new_document#guidance', as: :guidance
  get '/documents/new' => 'new_document#choose_supertype', as: :new_document
  post '/documents/new' => 'new_document#choose_document_type'
  post '/documents/create' => 'new_document#create', as: :create_document

  get '/documents/:id/publish' => 'publish_document#confirmation', as: :publish_document
  post '/documents/:id/publish' => 'publish_document#publish'

  get '/documents' => 'documents#index'
  get '/documents/:id/edit' => 'documents#edit', as: :edit_document
  patch '/documents/:id' => 'documents#update', as: :document
  get '/documents/:id' => 'documents#show'

  get '/documents/:id/associations' => 'document_associations#edit', as: :document_associations
  post '/documents/:id/associations' => 'document_associations#update'

  get "/healthcheck", to: proc { [200, {}, ["OK"]] }

  mount GovukPublishingComponents::Engine, at: "/component-guide"

  if Rails.env.test?
    get "/government/*all", to: proc { [200, {}, ["You've been redirected"]] }
  end
end
