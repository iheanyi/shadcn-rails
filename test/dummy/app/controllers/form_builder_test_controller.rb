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
      birthdate: Date.new(2026, 8, 29),
      meeting_at: Time.zone.local(2026, 8, 29, 14, 30, 15),
      follow_up_time: Time.zone.local(2026, 8, 29, 9, 5, 6),
      billing_month: Date.new(2026, 8, 1),
      signup_week: Date.new(2026, 8, 24),
      rating: 7,
      budget: 50,
      tags: params[:comma_tags] ? "vip,newsletter" : ["vip"],
      contact_method: "email",
      channels: ["email"],
      source: "website",
      addresses: [Address.new(city: "Lagos")]
    )
    if params[:invalid]
      @contact.valid?
      @contact.errors.add(:status, "can't be blank")
    end
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
