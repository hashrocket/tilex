defmodule Tilex.SharedViewTest do
  use TilexWeb.ConnCase, async: true

  import TilexWeb.SharedView

  @insert_time %{inserted_at: ~N[2016-11-18 03:34:08.142287]}

  describe "display_date/1" do
    test "it produces a human-readable date in server's timezone" do
      assert display_date(@insert_time) == "November 17, 2016"
    end
  end

  describe "pluralize/2" do
    test "counts 1" do
      assert pluralize(1, "hippo") == "1 hippo"
    end

    test "counts 2" do
      assert pluralize(2, "hippo") == "2 hippos"
    end
  end

  describe "rss_date/1" do
    test "renders rfc 822 dates" do
      assert rss_date(@insert_time) == "Fri, 18 Nov 2016 03:34:08 GMT"
    end
  end
end
