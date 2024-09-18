defmodule Tilex.NotificationsTest do
  use ExUnit.Case, async: true

  alias Tilex.Notifications

  @data [
    %{
      time_zone: "America/Chicago",
      input: ~N[2021-09-20 08:59:59.999],
      expected: ~N[2021-09-20 09:00:00.000000]
    },
    %{
      time_zone: "America/Chicago",
      input: ~N[2021-09-20 09:00:00.000],
      expected: ~N[2021-09-27 09:00:00.000000]
    },
    %{
      time_zone: "Europe/Paris",
      input: ~N[2021-09-20 08:59:59.999],
      expected: ~N[2021-09-20 09:00:00.000000]
    },
    %{
      time_zone: "Europe/Paris",
      input: ~N[2021-09-20 09:00:00.000],
      expected: ~N[2021-09-27 09:00:00.000000]
    }
  ]

  describe "next_report_time/1" do
    for %{input: input, time_zone: time_zone, expected: expected} <- @data do
      @input input
      @time_zone time_zone
      @expected expected

      test "gets the next Monday at 9 am when '#{inspect(@input)}' for #{@time_zone}" do
        now = DateTime.from_naive!(@input, @time_zone)
        expected = DateTime.from_naive!(@expected, @time_zone)
        assert Notifications.next_report_time(now) == expected
      end
    end
  end
end
