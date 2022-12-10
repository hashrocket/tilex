defmodule Tilex.TrackingTest do
  use Tilex.DataCase, async: true

  alias Tilex.Factory
  alias Tilex.Repo
  alias Tilex.Blog.Request
  alias Tilex.Tracking

  defp create_requests_for_post(post, view_count: count) do
    requests =
      1..count
      |> Enum.map(fn _ ->
        slugged_title =
          post.title
          |> String.downcase()
          |> String.replace(" ", "-")

        %{
          page: "/posts/" <> "#{post.slug}-#{slugged_title}",
          request_time: DateTime.utc_now() |> DateTime.truncate(:second)
        }
      end)

    Repo.insert_all(Request, requests)
  end

  describe ".most_viewed_posts" do
    test "returns the most viewed posts for a given week" do
      start_date = DateTime.utc_now() |> Timex.beginning_of_week()
      end_date = DateTime.utc_now() |> Timex.end_of_week()

      channel = Factory.insert!(:channel, name: "ruby")

      Factory.insert!(:post, title: "The Enderman Returns", slug: "101", channel: channel)
      |> create_requests_for_post(view_count: 4)

      Factory.insert!(:post, title: "Subnautica", slug: "102", channel: channel)
      |> create_requests_for_post(view_count: 3)

      Factory.insert!(:post, title: "Spiderman", slug: "103", channel: channel)
      |> create_requests_for_post(view_count: 2)

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

      expected_stats = [
        %{
          title: "The Enderman Returns",
          url: "/posts/101-the-enderman-returns",
          view_count: 4,
          channel_name: "ruby"
        },
        %{
          title: "Subnautica",
          url: "/posts/102-subnautica",
          view_count: 3,
          channel_name: "ruby"
        },
        %{
          title: "Spiderman",
          url: "/posts/103-spiderman",
          view_count: 2,
          channel_name: "ruby"
        }
      ]

      assert Tracking.most_viewed_posts(start_date, end_date) == expected_stats
    end

    test "returns at most 10 results" do
      start_date = DateTime.utc_now() |> Timex.beginning_of_week()
      end_date = DateTime.utc_now() |> Timex.end_of_week()

      channel = Factory.insert!(:channel, name: "example-channel")

      Factory.insert!(:post, title: "The Enderman Returns", slug: "101", channel: channel)
      |> create_requests_for_post(view_count: 4)

      Factory.insert!(:post, title: "Subnautica", slug: "102", channel: channel)
      |> create_requests_for_post(view_count: 3)

      Factory.insert!(:post, title: "Spiderman", slug: "103", channel: channel)
      |> create_requests_for_post(view_count: 2)

      Factory.insert!(:post, title: "Witcher 3", slug: "104", channel: channel)
      |> create_requests_for_post(view_count: 2)

      Factory.insert!(:post, title: "Doom", slug: "105", channel: channel)
      |> create_requests_for_post(view_count: 2)

      Factory.insert!(:post, title: "Doom 2", slug: "106", channel: channel)
      |> create_requests_for_post(view_count: 2)

      Factory.insert!(:post, title: "Doom 3", slug: "107", channel: channel)
      |> create_requests_for_post(view_count: 2)

      Factory.insert!(:post, title: "Castle Wolfenstein", slug: "108", channel: channel)
      |> create_requests_for_post(view_count: 2)

      Factory.insert!(:post, title: "Minecraft", slug: "109", channel: channel)
      |> create_requests_for_post(view_count: 2)

      Factory.insert!(:post, title: "Red Dead Redemption", slug: "110", channel: channel)
      |> create_requests_for_post(view_count: 2)

      Factory.insert!(:post, title: "Halo", slug: "111")

      Factory.insert!(
        :request,
        page: "/posts/111-halo",
        request_time: start_date |> DateTime.truncate(:second)
      )

      expected_stats = [
        %{
          channel_name: "example-channel",
          title: "The Enderman Returns",
          url: "/posts/101-the-enderman-returns",
          view_count: 4
        },
        %{
          channel_name: "example-channel",
          title: "Subnautica",
          url: "/posts/102-subnautica",
          view_count: 3
        },
        %{
          channel_name: "example-channel",
          title: "Spiderman",
          url: "/posts/103-spiderman",
          view_count: 2
        },
        %{
          channel_name: "example-channel",
          title: "Witcher 3",
          url: "/posts/104-witcher-3",
          view_count: 2
        },
        %{channel_name: "example-channel", title: "Doom", url: "/posts/105-doom", view_count: 2},
        %{
          channel_name: "example-channel",
          title: "Doom 2",
          url: "/posts/106-doom-2",
          view_count: 2
        },
        %{
          channel_name: "example-channel",
          title: "Doom 3",
          url: "/posts/107-doom-3",
          view_count: 2
        },
        %{
          channel_name: "example-channel",
          title: "Castle Wolfenstein",
          url: "/posts/108-castle-wolfenstein",
          view_count: 2
        },
        %{
          channel_name: "example-channel",
          title: "Minecraft",
          url: "/posts/109-minecraft",
          view_count: 2
        },
        %{
          channel_name: "example-channel",
          title: "Red Dead Redemption",
          url: "/posts/110-red-dead-redemption",
          view_count: 2
        }
      ]

      assert Tracking.most_viewed_posts(start_date, end_date) == expected_stats
    end
  end

  describe ".total_page_views" do
    test "returns the total page views for a date range" do
      start_date = DateTime.utc_now() |> Timex.beginning_of_week()
      end_date = DateTime.utc_now() |> Timex.end_of_week()

      Repo.delete_all(Tilex.Blog.Request)

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
