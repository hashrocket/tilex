defmodule Features.DeveloperSignsOutTest do
  use Tilex.IntegrationCase, async: Application.get_env(:tilex, :async_feature_test)

  test 'signs out and does not see create post link', %{:session => session} do
    developer = Factory.insert!(:developer)

    session
    |> sign_in(developer)
    |> visit("/")
    |> click(Query.link("Sign Out"))

    refute has?(session, Query.link("Create Post"))
  end
end
