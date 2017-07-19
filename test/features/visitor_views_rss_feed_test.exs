defmodule VisitorViewsRSSFeed do
  use Tilex.IntegrationCase, async: Application.get_env(:tilex, :async_feature_test)

  test "via the legacy atom query parameter", %{session: session} do
    visit(session, "/?format=atom")
    assert current_path(session) == "/rss"
  end

  test "via an alternate RSS query parameter", %{session: session} do
    visit(session, "/?format=rss")
    assert current_path(session) == "/rss"
  end
end
