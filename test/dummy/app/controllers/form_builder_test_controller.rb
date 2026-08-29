# frozen_string_literal: true

class FormBuilderTestController < ApplicationController
  skip_forgery_protection

  def new
    @contact = Contact.new(
      email: params[:invalid] ? "" : "person@example.com",
      notes: "Initial notes",
      subscribed: "1",
      notifications: "1",
      status: "customer",
      addresses: [Address.new(city: "Lagos")]
    )
    @contact.valid? if params[:invalid]
  end

  def form_for
    @contact = Contact.new(
      email: "legacy@example.com",
      notes: "Legacy notes",
      subscribed: false,
      status: "lead",
      addresses: [Address.new(city: "Enugu")]
    )
  end

  def create
    render json: params.require(:contact).permit(
      :email,
      :notes,
      :subscribed,
      :notifications,
      :status,
      addresses_attributes: [:city]
    )
  end
end
