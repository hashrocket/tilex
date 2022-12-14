defmodule TilexWeb.StructuredDataView do
  alias TilexWeb.Router.Helpers, as: Routes
  alias Tilex.Blog.Post

  @organization_ld %{
    "@context" => "http://schema.org",
    "@type" => "Organization",
    "name" => "Hashrocket",
    "url" => "https://hashrocket.com",
    "image" => "https://hashrocket.com/hashrocket_logo.svg",
    "logo" => "https://hashrocket.com/hashrocket_logo.svg",
    "telephone" => "1-904-339-7047",
    "duns" => "015835393",
    "foundingDate" => "2008-01-22",
    "founder" => %{
      "@type" => "Person",
      "url" => "http://marianphelan.com",
      "name" => "Marian Phelan",
      "jobTitle" => "CEO"
    },
    "brand" => %{
      "@type" => "Brand",
      "name" => "Hashrocket",
      "url" => "https://hashrocket.com",
      "logo" => "https://hashrocket.com/hashrocket_logo.svg"
    },
    "address" => %{
      "@type" => "PostalAddress",
      "streetAddress" => "320 1st St. N #714",
      "addressLocality" => "Jacksonville Beach",
      "addressRegion" => "FL",
      "postalCode" => "32250",
      "addressCountry" => "US"
    },
    "sameAs" => [
      "https://clutch.co/profile/hashrocket",
      "https://coderwall.com/team/hashrocket",
      "https://dribbble.com/hashrocket",
      "https://www.facebook.com/hashrocket",
      "https://github.com/hashrocket",
      "https://plus.google.com/+hashrocket",
      "https://www.linkedin.com/company/hashrocket",
      "https://twitter.com/hashrocket",
      "https://www.youtube.com/hashrocket",
      "https://vimeo.com/hashrocket"
    ]
  }

  def organization_ld, do: @organization_ld

  def post_ld(conn, %Post{channel: channel, developer: developer} = post) do
    author_same_as =
      case developer.twitter_handle do
        nil -> []
        handle -> ["https://twitter.com/#{handle}"]
      end

    %{
      "@context" => "http://schema.org",
      "@type" => "BlogPosting",
      "headline" => post.title,
      "articleBody" => post.body,
      "articleSection" => channel.name,
      "mainEntityOfPage" => Routes.post_url(conn, :show, post),
      "image" => Routes.static_url(conn, "/images/til-logo-512x512.png"),
      "datePublished" => DateTime.to_date(post.inserted_at),
      "dateModified" => DateTime.to_date(post.updated_at),
      "author" => %{
        "@type" => "Person",
        "name" => developer.username,
        "url" => Routes.developer_url(conn, :show, developer),
        "sameAs" => author_same_as
      },
      "publisher" => @organization_ld
    }
  end
end
