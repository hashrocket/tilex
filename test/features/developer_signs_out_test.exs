defmodule Features.DeveloperSignsOutTest do
  use Tilex.IntegrationCase, async: Application.get_env(:tilex, :async_feature_test)

  test 'signs out and sees a flash message', %{:session => session} do
    developer = Factory.insert!(:developer)

    session
    |> sign_in(developer)
    |> click(Query.link("Sign Out"))
    |> Browser.find(Query.css(".alert-info", text: "Signed out"))
  end
end
