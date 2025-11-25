# frozen_string_literal: true

class PagesController < ApplicationController
  def index
  end

  def components
    @components = Shadcn::Rails.available_components
  end

  def show_component
    @component = params[:component]
    unless Shadcn::Rails.component_exists?(@component)
      redirect_to components_path, alert: "Component not found"
    end
  end
end
