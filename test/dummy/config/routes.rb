# frozen_string_literal: true

Rails.application.routes.draw do
  root "pages#index"

  get "components", to: "pages#components"
  get "showcase", to: "pages#showcase"
  get "themes", to: "pages#themes"
  get "buttons", to: "pages#buttons"
  get "forms", to: "pages#forms"
  get "dialogs", to: "pages#dialogs"
  get "cards", to: "pages#cards"
  get "tabs", to: "pages#tabs"

  # Mount Lookbook if available
  if defined?(Lookbook)
    mount Lookbook::Engine, at: "/lookbook"
  end
end
