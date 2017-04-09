defmodule Features.DeveloperSignsOutTest do
  use Tilex.IntegrationCase

  test 'signs out and does not see create post link', %{:session => session} do

    Factory.insert!(:channel, name: "phoenix")
    developer = Factory.insert!(:developer)

    session
    |> sign_in(developer)
    |> visit("/")
    |> click(Query.link("Sign Out"))

    refute has?(session, Query.link("Create Post"))
  end
end
