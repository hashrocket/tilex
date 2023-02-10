defmodule Tilex.LinkedinApiTest do
  use ExUnit.Case, async: true
  import Tesla.Mock
  alias Tilex.LinkedinApi

  describe "create_post/3" do
    test "create post on Linkedin" do
      mock(fn req ->
        assert req.url == "https://api.linkedin.com/v2/posts"
        assert req.method == :post

        assert req.headers == [
                 {"authorization", "Bearer my-access-token"},
                 {"content-type", "application/json"}
               ]

        assert %{
                 "author" => "urn:li:organization:my-org-id",
                 "commentary" => "my-comment",
                 "content" => %{
                   "article" => %{
                     "source" => "http://url.example.com",
                     "title" => "my-title"
                   }
                 }
               } = Jason.decode!(req.body)

        %Tesla.Env{status: 200, body: "hello"}
      end)

      :ok = LinkedinApi.create_post("my-comment", "my-title", "http://url.example.com")
    end
  end
end
