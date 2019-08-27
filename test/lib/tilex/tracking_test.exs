defmodule Tilex.TrackingTest do
  use Tilex.ModelCase, async: true

  alias Tilex.Factory
  alias Tilex.Repo
  alias Tilex.Request
  alias Tilex.Tracking

  defp create_requests_from_stats(stats) do
    requests =
      stats
      |> Enum.flat_map(fn %{title: title, view_count: count, url: url} ->
        slug = Regex.named_captures(~r[/posts/(?<slug>.+?)-], url)["slug"]

        Factory.insert!(:post, title: title, slug: slug)

        1..count
        |> Enum.map(fn _ ->
          %{
            page: url,
            request_time: DateTime.utc_now() |> DateTime.truncate(:second)
          }
        end)
      end)

    Repo.insert_all(Request, requests)
  end

  describe ".most_viewed_posts" do
    test "returns the most viewed posts for a given week" do
      start_date = DateTime.utc_now() |> Timex.beginning_of_week()
      end_date = DateTime.utc_now() |> Timex.end_of_week()

      stats = [
        %{title: "The Enderman Returns", url: "/posts/101-the-enderman-returns", view_count: 4},
        %{title: "Subnautica", url: "/posts/102-subnautica", view_count: 3},
        %{title: "Spiderman", url: "/posts/103-spiderman", view_count: 2}
      ]

      create_requests_from_stats(stats)

      outside_request_time =
        end_date
        |> Timex.add(Timex.Duration.from_days(1))
        |> DateTime.truncate(:second)

      Factory.insert!(
        :request,
        page: "/posts/112-outside-range",
        request_time: outside_request_time
      )

      Factory.insert!(
        :request,
        page: "/posts/new",
        request_time: start_date |> DateTime.truncate(:second)
      )

      assert Tracking.most_viewed_posts(start_date, end_date) == stats
    end

    test "returns at most 10 results" do
      start_date = DateTime.utc_now() |> Timex.beginning_of_week()
      end_date = DateTime.utc_now() |> Timex.end_of_week()

      stats = [
        %{title: "The Enderman Returns", url: "/posts/101-the-enderman-returns", view_count: 4},
        %{title: "Subnautica", url: "/posts/102-subnautica", view_count: 3},
        %{title: "Spiderman", url: "/posts/103-spiderman", view_count: 2},
        %{title: "Witcher 3", url: "/posts/104-witcher-3", view_count: 2},
        %{title: "Doom", url: "/posts/105-doom", view_count: 2},
        %{title: "Doom 2", url: "/posts/106-doom 2", view_count: 2},
        %{title: "Doom 3", url: "/posts/107-doom 3", view_count: 2},
        %{title: "Castle Wolfenstein", url: "/posts/108-castle-wolfenstein", view_count: 2},
        %{title: "Minecraft", url: "/posts/109-minecraft", view_count: 2},
        %{title: "Red Dead Redemption", url: "/posts/110-red-dead-redemption", view_count: 2}
      ]

      create_requests_from_stats(stats)

      Factory.insert!(:post, title: "Halo", slug: "111")

      Factory.insert!(
        :request,
        page: "/posts/111-halo",
        request_time: start_date |> DateTime.truncate(:second)
      )

      assert Tracking.most_viewed_posts(start_date, end_date) == stats
    end
  end

  describe ".total_page_views" do
    test "returns the total page views for a date range" do
      start_date = DateTime.utc_now() |> Timex.beginning_of_week()
      end_date = DateTime.utc_now() |> Timex.end_of_week()

      Repo.delete_all(Tilex.Request)

      1..12
      |> Enum.each(fn _ ->
        Factory.insert!(
          :request,
          request_time: start_date |> DateTime.truncate(:second)
        )
      end)

      outside_request_time =
        end_date
        |> Timex.add(Timex.Duration.from_days(1))
        |> DateTime.truncate(:second)

      Factory.insert!(
        :request,
        request_time: outside_request_time
      )

      assert Tracking.total_page_views(start_date, end_date) == 12
    end
  end
end
