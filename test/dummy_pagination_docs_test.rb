# frozen_string_literal: true

require "test_helper"

class DummyPaginationDocsTest < ActionDispatch::IntegrationTest
  PLACEHOLDER_COPY = "This example now renders from the component preview source shown by the showcase block on this page."

  def test_gem_integration_docs_render_real_snippets_and_live_links
    get "/docs/components/pagination"

    assert_response :success
    assert_select "h2", text: "Gem Integration"
    assert_select "h3", text: "Pagy"
    assert_select "h3", text: "Kaminari"
    assert_select "h3", text: "will_paginate"
    assert_select "h3", text: "Custom URL Builder"
    assert_select "turbo-frame#pagy-demo.scroll-mt-24"
    assert_select "turbo-frame#kaminari-demo.scroll-mt-24"
    assert_select "turbo-frame#will-paginate-demo.scroll-mt-24"
    assert_select "turbo-frame#custom-url-builder-demo.scroll-mt-24"
    assert_select "turbo-frame#window-size-demo.scroll-mt-24"
    assert_select "a[href='/docs/components/pagination?page=2#kaminari-demo']", minimum: 1
    assert_select "a[href='/docs/components/pagination?page=2#pagy-demo']", minimum: 1
    assert_match %r{/docs/components/pagination\?(?:page=2&amp;filter=published|filter=published&amp;page=2)#custom-url-builder-demo}, response.body
    assert_select "turbo-frame#kaminari-demo span[aria-disabled='true']", text: /Previous/
    assert_select "turbo-frame#pagy-demo span[aria-disabled='true']", text: /Previous/
    assert_includes response.body, "pagy: @pagy"
    assert_includes response.body, "Post.page(params[:page])"
    assert_includes response.body, "Kaminari.paginate_array"
    assert_includes response.body, "shadcn_paginate @posts"
    assert_includes response.body, "render Shadcn::Pagination.new"
    assert_includes response.body, "collection: @posts"
    assert_includes response.body, "posts_path(page: page, anchor:"
    assert_includes response.body, "turbo_frame_tag"
    assert_includes response.body, "url_builder:"
    assert_includes response.body, "content.with_item(href: posts_path(page: 2), active: true)"
    assert_includes response.body, "content.with_ellipse"
    assert_includes response.body, "content.with_previous(disabled: true)"
    assert_includes response.body, "window: 1"
    refute_includes response.body, PLACEHOLDER_COPY
  end

  def test_live_demo_uses_page_param_for_visible_records
    get "/docs/components/pagination?page=2"

    assert_response :success
    assert_includes response.body, "showing page 2 of 10"
    assert_includes response.body, "Demo post 6"
    assert_includes response.body, "Demo post 10"
    assert_select "a[aria-current='page']", text: "2", minimum: 1
  end

  def test_live_demo_disables_next_on_last_page
    get "/docs/components/pagination?page=10"

    assert_response :success
    assert_includes response.body, "showing page 10 of 10"
    assert_select "turbo-frame#kaminari-demo span[aria-disabled='true']", text: /Next/
    assert_select "turbo-frame#pagy-demo span[aria-disabled='true']", text: /Next/
  end
end
