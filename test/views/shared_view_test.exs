defmodule Tilex.SharedViewTest do
  use Tilex.Web.ConnCase

  import Tilex.Web.SharedView

  test "renders rfc 822 dates" do
    time = %{inserted_at: ~N[2002-10-02 08:00:00.142287]}
    assert rss_date(time) == "Wed, 02 Oct 2002 08:00:00 GMT"
  end
end
