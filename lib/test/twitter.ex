defmodule Test.Twitter do

  @moduledoc """
    Mocks Twitter functions for testing.
  """

  def notify(_post, _developer, _channel, _url) do
    :ok
  end
end
