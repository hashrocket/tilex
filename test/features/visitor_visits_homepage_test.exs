defmodule VisitorVisitsHomepageTest do
  use TodayILearned.IntegrationCase

  test "the page title is TIL" do
    navigate_to("/")

    assert page_title == "Today I Learned"
  end
end
