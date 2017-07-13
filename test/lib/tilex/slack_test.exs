defmodule Lib.Tilex.SlackTest do
  use ExUnit.Case, async: true

  alias Tilex.{Channel, Post, Developer, Slack}

  describe "prepare_text/4" do
    test "prepares a Slack text payload" do
      post = %Post{title: "monads are cool"}
      developer = %Developer{username: "makinpancakes"}
      channel = %Channel{name: "haskell"}
      url = "https://til.hashrocket.com"

      result = Slack.prepare_text(post, developer, channel, url)

      assert result == "makinpancakes created a new post <https://til.hashrocket.com|monads are cool> #haskell"
    end
  end
end
