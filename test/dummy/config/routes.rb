# frozen_string_literal: true

Rails.application.routes.draw do
  # Health check for Fly.io
  get "up", to: ->(_env) { [200, {}, ["OK"]] }

  root "pages#index"

  get "components", to: "pages#components"
  get "showcase", to: redirect("/docs/components", status: 301)
  get "themes", to: "pages#themes"
  get "customization", to: "pages#customization"
  get "buttons", to: "pages#buttons"
  get "forms", to: "pages#forms"
  get "dialogs", to: "pages#dialogs"
  get "cards", to: "pages#cards"
  get "tabs", to: "pages#tabs"

  # Component Documentation
  get "docs", to: "docs#index", as: :docs
  get "docs/components", to: "docs#components", as: :docs_components
  get "docs/examples/editor", to: "docs#editor_example", as: :docs_editor_example
  post "docs/examples/editor", to: "docs#editor_example"
  get "docs/components/:slug", to: "docs#show", as: :docs_component
  get "form_builder_test/new", to: "form_builder_test#new"
  get "form_builder_test/form_for", to: "form_builder_test#form_for"
  post "form_builder_test", to: "form_builder_test#create"

  # UX Test Application
  get "app", to: "app#dashboard"
  get "app/dashboard", to: "app#dashboard"
  get "app/settings", to: "app#settings"
  get "app/profile", to: "app#profile"
  get "app/notifications", to: "app#notifications"

  # Mount Lookbook if available
  if defined?(Lookbook)
    mount Lookbook::Engine, at: "/lookbook"
  end
end
