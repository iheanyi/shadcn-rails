# frozen_string_literal: true

class ApplicationComponent < ViewComponent::Base
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Context
end
