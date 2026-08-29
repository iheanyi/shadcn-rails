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
      rating: 7,
      budget: 50,
      tags: ["vip"],
      contact_method: "email",
      channels: ["email"],
      source: "website",
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
      rating: 3,
      budget: 25,
      tags: [],
      contact_method: "phone",
      channels: [],
      source: "referral",
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
      :rating,
      :budget,
      :tags,
      :contact_method,
      :source,
      channels: [],
      addresses_attributes: [:city]
    )
  end
end
