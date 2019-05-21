defmodule Tilex.DateTimeMock do
  use Agent

  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def utc_now do
    Agent.get_and_update(__MODULE__, fn
      [] ->
        {Timex.now(), []}

      [current | rest] ->
        {current, rest}
    end)
  end
end
