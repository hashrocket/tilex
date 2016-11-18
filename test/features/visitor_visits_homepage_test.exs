defmodule VisitorVisitsHomepageTest do
  use TodayILearned.IntegrationCase

  test "the page has the appropriate branding" do
    navigate_to("/")

    assert page_title == "Today I Learned"
    assert visible_in_element?({:tag, "h1"}, ~r/Today I Learned/i)
  end
end
