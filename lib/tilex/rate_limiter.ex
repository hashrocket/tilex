defmodule Tilex.RateLimiter do
  use GenServer

  @name __MODULE__
  @date_time_module Application.get_env(:tilex, :date_time_module)
  @limit Application.get_env(:tilex, :rate_limiter_requests_per_time_period)
  @time_period_minutes Application.get_env(:tilex, :rate_limiter_time_period_minutes)

  # Client ----------------------------------------------

  def start_link do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def check(ip: ip) do
    GenServer.call(@name, {:check_ip, ip})
  end

  # Server ----------------------------------------------

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:check_ip, ip}, _from, state) do
    request_times = state |> Map.get(ip, [])
    current_time = @date_time_module.utc_now()
    end_time = Timex.subtract(current_time, Timex.Duration.from_minutes(@time_period_minutes))

    recent_request_times =
      Enum.filter(request_times, fn time ->
        Timex.between?(time, end_time, current_time, inclusive: true)
      end)

    current_requests = [current_time | recent_request_times]
    new_state = Map.put(state, ip, current_requests)

    {:reply, length(current_requests) <= @limit, new_state}
  end
end
