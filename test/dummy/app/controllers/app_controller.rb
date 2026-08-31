# frozen_string_literal: true

class AppController < ApplicationController
  DataTablePage = Struct.new(:current_page, :total_pages, keyword_init: true)

  layout "app"

  before_action :prepare_dashboard, only: :dashboard
  before_action :prepare_settings, only: :settings
  before_action :prepare_profile, only: :profile
  before_action :prepare_notifications, only: :notifications

  def dashboard; end

  def settings; end

  def profile; end

  def notifications; end

  private

  def prepare_dashboard
    @dashboard_search = params[:q].to_s
    @dashboard_status = params[:status].to_s
    @dashboard_sort = params[:sort].to_s
    @dashboard_dir = %w[asc desc].include?(params[:dir].to_s) ? params[:dir].to_s : nil

    records = dashboard_transactions
    records = filter_dashboard_transactions(records)
    records = sort_dashboard_transactions(records)

    @transactions_total_count = records.length
    @transactions = Kaminari.paginate_array(records).page(params[:page]).per(5)
    @transactions_page = DataTablePage.new(
      current_page: @transactions.current_page,
      total_pages: @transactions.total_pages
    )

    @dashboard_stats = [
      { label: "Total Revenue", value: "$45,231.89", change: "+20.1% from last month", icon: :revenue },
      { label: "Subscriptions", value: "+2,350", change: "+180.1% from last month", icon: :users },
      { label: "Sales", value: "+12,234", change: "+19% from last month", icon: :sales },
      { label: "Active Now", value: "+573", change: "+201 since last hour", icon: :activity }
    ]

    @sales_chart_data = {
      labels: %w[Jun Jul Aug Sep Oct Nov],
      datasets: [
        {
          label: "Revenue",
          data: [18_200, 21_400, 19_800, 25_600, 31_200, 45_231],
          backgroundColor: "hsl(var(--chart-1))",
          borderColor: "hsl(var(--chart-1))"
        },
        {
          label: "Sales",
          data: [7_200, 8_600, 8_100, 9_400, 10_900, 12_234],
          backgroundColor: "hsl(var(--chart-2))",
          borderColor: "hsl(var(--chart-2))"
        }
      ]
    }
    @sales_chart_config = {
      revenue: { label: "Revenue", color: "hsl(var(--chart-1))" },
      sales: { label: "Sales", color: "hsl(var(--chart-2))" }
    }
    @recent_sales = dashboard_transactions.select { |transaction| transaction[:status] == "Completed" }.first(5)
  end

  def filter_dashboard_transactions(records)
    filtered = records
    filtered = filtered.select { |record| record[:status] == @dashboard_status } if @dashboard_status.present?

    return filtered if @dashboard_search.blank?

    query = @dashboard_search.downcase
    filtered.select do |record|
      record.values_at(:customer, :email, :status).any? { |value| value.to_s.downcase.include?(query) }
    end
  end

  def sort_dashboard_transactions(records)
    sorters = {
      "customer" => ->(record) { record[:customer].downcase },
      "email" => ->(record) { record[:email].downcase },
      "status" => ->(record) { record[:status].downcase },
      "date" => ->(record) { record[:date] },
      "amount" => ->(record) { record[:amount_cents] }
    }
    sorter = sorters[@dashboard_sort]
    return records unless sorter && @dashboard_dir

    sorted = records.sort_by(&sorter)
    @dashboard_dir == "desc" ? sorted.reverse : sorted
  end

  def dashboard_transactions
    [
      { customer: "Olivia Martin", email: "olivia@email.com", initials: "OM", status: "Completed", date: Date.new(2024, 11, 24), amount_cents: 199_900 },
      { customer: "Jackson Lee", email: "jackson@email.com", initials: "JL", status: "Pending", date: Date.new(2024, 11, 23), amount_cents: 3_900 },
      { customer: "Isabella Nguyen", email: "isabella@email.com", initials: "IN", status: "Completed", date: Date.new(2024, 11, 22), amount_cents: 29_900 },
      { customer: "William Kim", email: "will@email.com", initials: "WK", status: "Failed", date: Date.new(2024, 11, 21), amount_cents: 9_900 },
      { customer: "Sofia Davis", email: "sofia@email.com", initials: "SD", status: "Completed", date: Date.new(2024, 11, 20), amount_cents: 3_900 },
      { customer: "Noah Garcia", email: "noah@email.com", initials: "NG", status: "Processing", date: Date.new(2024, 11, 19), amount_cents: 19_900 },
      { customer: "Ava Thompson", email: "ava@email.com", initials: "AT", status: "Completed", date: Date.new(2024, 11, 18), amount_cents: 75_000 },
      { customer: "Mia Wilson", email: "mia@email.com", initials: "MW", status: "Pending", date: Date.new(2024, 11, 17), amount_cents: 24_900 },
      { customer: "Ethan Clark", email: "ethan@email.com", initials: "EC", status: "Completed", date: Date.new(2024, 11, 16), amount_cents: 50_000 },
      { customer: "Amelia Brown", email: "amelia@email.com", initials: "AB", status: "Failed", date: Date.new(2024, 11, 15), amount_cents: 7_500 },
      { customer: "Lucas Miller", email: "lucas@email.com", initials: "LM", status: "Processing", date: Date.new(2024, 11, 14), amount_cents: 12_000 },
      { customer: "Maya Chen", email: "maya@email.com", initials: "MC", status: "Completed", date: Date.new(2024, 11, 13), amount_cents: 64_200 }
    ]
  end

  def prepare_settings
    submitted = params.fetch(:settings, {}).permit(
      :first_name,
      :last_name,
      :email,
      :bio,
      :language,
      :timezone,
      :font_size,
      :marketing_emails,
      :security_alerts,
      :weekly_digest,
      :transaction_receipts,
      :push_all,
      :push_direct,
      :push_mentions,
      :current_password,
      :new_password,
      :confirm_password,
      :two_factor
    )

    @settings = {
      first_name: submitted[:first_name].presence || "John",
      last_name: submitted[:last_name].presence || "Doe",
      email: submitted[:email].presence || "john@acme.com",
      bio: submitted[:bio].presence || "Building great products with Ruby on Rails.",
      language: submitted[:language].presence || "en",
      timezone: submitted[:timezone].presence || "utc",
      font_size: submitted[:font_size].presence || "16",
      marketing_emails: checked_param?(submitted, :marketing_emails, false),
      security_alerts: checked_param?(submitted, :security_alerts, true),
      weekly_digest: checked_param?(submitted, :weekly_digest, true),
      transaction_receipts: checked_param?(submitted, :transaction_receipts, true),
      push_all: checked_param?(submitted, :push_all, true),
      push_direct: checked_param?(submitted, :push_direct, true),
      push_mentions: checked_param?(submitted, :push_mentions, false),
      two_factor: checked_param?(submitted, :two_factor, false)
    }
  end

  def prepare_profile
    submitted = params.fetch(:profile, {}).permit(:display_name, :username, :bio)
    @profile = {
      display_name: submitted[:display_name].presence || "John Doe",
      username: submitted[:username].presence || "johndoe",
      bio: submitted[:bio].presence || "Senior Software Engineer at Acme Inc. Building great products with Ruby on Rails."
    }
  end

  def prepare_notifications
    @notifications_marked_read = params[:mark_all] == "1"
  end

  def checked_param?(params_hash, key, default)
    return default unless params_hash.key?(key)

    ActiveModel::Type::Boolean.new.cast(params_hash[key])
  end
end
