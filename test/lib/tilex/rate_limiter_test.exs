defmodule Tilex.RateLimiterTest do
  use ExUnit.Case, async: false

  alias Tilex.RateLimiter
  alias Tilex.DateTimeMock

  setup do
    RateLimiter.start_link()
    :ok
  end

  test "it responds to valid calls with true" do
    DateTimeMock.start_link([])
    assert RateLimiter.check(ip: "abc.def.ghi.123")
  end

  test "it responds to invalid calls with false" do
    ip = "1.1.1.1"
    now = DateTime.utc_now()

    times =
      [25, 20, 15, 10, 5, 1]
      |> Enum.map(fn seconds -> Timex.subtract(now, Timex.Duration.from_seconds(seconds)) end)

    DateTimeMock.start_link(times)

    1..5
    |> Enum.each(fn _ ->
      assert RateLimiter.check(ip: ip)
    end)

    assert RateLimiter.check(ip: ip) == false
  end

  test "it responds with true if requests are spread over more than 1 minute" do
    ip = "1.1.1.1"
    now = DateTime.utc_now()

    times =
      [62, 20, 15, 10, 5, 1]
      |> Enum.map(fn seconds -> Timex.subtract(now, Timex.Duration.from_seconds(seconds)) end)

    DateTimeMock.start_link(times)

    1..5
    |> Enum.each(fn _ ->
      assert RateLimiter.check(ip: ip)
    end)

    assert RateLimiter.check(ip: ip) == true
  end
end
