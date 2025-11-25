# frozen_string_literal: true

Rails.application.routes.draw do
  # Root path
  root "pages#index"

  # Component showcase
  get "components", to: "pages#components"
  get "components/:component", to: "pages#show_component", as: :component

  # Mount Lookbook in development/test
  if Rails.env.development? || Rails.env.test?
    mount Lookbook::Engine, at: "/lookbook"
  end
end
