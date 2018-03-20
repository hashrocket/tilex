defmodule TilexWeb.Schema do
  use Absinthe.Schema

  import_types(TilexWeb.Schema.PostTypes)

  alias TilexWeb.Resolvers

  query do
    @desc "Get posts"
    field :posts, list_of(:post) do
      arg(:page, :integer, default_value: 1)
      arg(:limit, :integer, default_value: 3)
      arg(:developer_username, :string)
      resolve(&Resolvers.Post.resolved_posts/3)
    end
  end
end
