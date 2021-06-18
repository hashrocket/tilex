defmodule Tilex.RateLimiter do
  use GenServer

  @table_name :rate_limiter_lookup

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @spec check(ip: String.t()) :: boolean()
  def check(ip: ip) do
    request_times = lookup_ip(ip)
    current_time = date_time_module().utc_now()
    recent_request_times = filter_recent_request_times(current_time, request_times)
    current_requests = [current_time | recent_request_times]

    :ets.insert(@table_name, {ip, current_requests})

    length(current_requests) <= limit()
  end

  @impl true
  def init(_) do
    create_table()
    schedule_cleanup()
    {:ok, %{}}
  end

  @impl true
  def handle_info(:cleanup, state) do
    :ets.delete_all_objects(@table_name)
    schedule_cleanup()
    {:noreply, state}
  end

  defp create_table do
    :ets.new(@table_name, [
      :set,
      :public,
      :named_table,
      read_concurrency: true,
      write_concurrency: true
    ])
  end

  defp lookup_ip(ip) do
    case :ets.lookup(@table_name, ip) do
      [{^ip, requests}] -> requests
      _ -> []
    end
  end

  defp filter_recent_request_times(current_time, request_times) do
    end_time = Timex.subtract(current_time, time_period_minutes())

    Enum.filter(request_times, fn time ->
      Timex.between?(time, end_time, current_time, inclusive: true)
    end)
  end

  defp schedule_cleanup do
    Process.send_after(self(), :cleanup, cleanup_interval())
  end

  defp date_time_module(), do: Application.get_env(:tilex, :date_time_module)

  defp limit(), do: Application.get_env(:tilex, :rate_limiter_requests_per_time_period)

  defp cleanup_interval(), do: Application.get_env(:tilex, :rate_limiter_cleanup_interval)

  defp time_period_minutes() do
    :tilex
    |> Application.get_env(:rate_limiter_time_period_minutes)
    |> Timex.Duration.from_minutes()
  end
end
