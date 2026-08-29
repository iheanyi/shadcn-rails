# frozen_string_literal: true

class Contact
  include ActiveModel::Model

  attr_accessor :email, :notes, :subscribed, :notifications, :status, :addresses

  validates :email, presence: true

  def self.statuses
    {
      "lead" => 0,
      "customer" => 1,
      "archived" => 2
    }
  end

  def initialize(attributes = {})
    super
    self.addresses ||= [Address.new]
  end
end
