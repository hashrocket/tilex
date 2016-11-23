defmodule VisitorViewsPostTest do
  use TodayILearned.IntegrationCase

  test "the page shows a post" do

    special = EctoFactory.insert(:post, title: "A special post")
    EctoFactory.insert(:post, title: "A random post")

    navigate_to("/posts/#{special.id}")

    assert visible_in_page?(~r/A special post/)
    refute visible_in_page?(~r/A random post/)
  end
end
