defmodule Lib.Tilex.MarkdownTest do
  use ExUnit.Case, async: true

  alias Tilex.Markdown

  @to_html_data [
    %{
      input: "",
      html: "",
      content: ""
    },
    %{
      input: "Pure content!",
      html: "<p>\nPure content!</p>",
      content: "Pure content!"
    },
    %{
      input: "with 😀 emoji",
      html: "<p>\nwith 😀 emoji</p>",
      content: "with 😀 emoji"
    },
    %{
      input: "with *italic* word",
      html: "<p>\nwith <em>italic</em> word</p>",
      content: "with italic word"
    },
    %{
      input: "with **bold** word",
      html: "<p>\nwith <strong>bold</strong> word</p>",
      content: "with bold word"
    },
    %{
      input: "html<br />newline",
      html: "<p>\nhtml&lt;br /&gt;newline</p>",
      content: "html\nnewline"
    },
    %{
      input: "regular\nnewline",
      html: "<p>\nregular\nnewline</p>",
      content: "regular\nnewline"
    },
    %{
      input: "double\n\nnewline",
      html: "<p>\ndouble</p>\n<p>\nnewline</p>",
      content: "double\nnewline"
    },
    %{
      input: "<div>html only</div>",
      html: "<div>\n  html only</div>",
      content: "html only"
    },
    %{
      input: "markdown paragraph <div>with html</div>",
      html: "<p>\nmarkdown paragraph &lt;div&gt;with html&lt;/div&gt;</p>",
      content: "markdown paragraph with html"
    },
    %{
      input: "<div>nested <span>html</span></div>",
      html: "<div>\n  nested <span>html</span></div>",
      content: "nested html"
    },
    %{
      input: "special chars \" ” ' ‘",
      html: "<p>\nspecial chars \" ” ' ‘</p>",
      content: "special chars \" ” ' ‘"
    },
    %{
      input: "full [link](http://link.com?foo=bar)",
      html: "<p>\nfull <a href=\"http://link.com?foo=bar\">link</a></p>",
      content: "full link"
    },
    %{
      input: "relative [link](/link.com?foo=bar)",
      html: "<p>\nrelative <a href=\"/link.com?foo=bar\">link</a></p>",
      content: "relative link"
    },
    %{
      input: "ref [my-link]\n\n[my-link]: http://foo/bar",
      html: "<p>\nref <a href=\"http://foo/bar\" title=\"\">my-link</a></p>",
      content: "ref my-link"
    },
    %{
      input: "ref titled [my-link]\n\n[my-link]: http://foo/bar \"My Title\"",
      html: "<p>\nref titled <a href=\"http://foo/bar\" title=\"My Title\">my-link</a></p>",
      content: "ref titled my-link"
    },
    %{
      input: "inline html <a href=\"http://link.com?foo=bar\">full link</a>",
      html: "<p>\ninline html &lt;a href=\"http://link.com?foo=bar\"&gt;full link&lt;/a&gt;</p>",
      content: "inline html full link"
    },
    %{
      input: "inline html <a href=\"/link.com?foo=bar\">relative link</a>",
      html: "<p>\ninline html &lt;a href=\"/link.com?foo=bar\"&gt;relative link&lt;/a&gt;</p>",
      content: "inline html relative link"
    },
    %{
      input: "plain full http://link.com?foo=bar",
      html: "<p>\nplain full http://link.com?foo=bar</p>",
      content: "plain full http://link.com?foo=bar"
    },
    %{
      input: "plain relative /link.com?foo=bar",
      html: "<p>\nplain relative /link.com?foo=bar</p>",
      content: "plain relative /link.com?foo=bar"
    },
    %{
      input: "inline `code` block",
      html: "<p>\ninline <code class=\"inline\">code</code> block</p>",
      content: "inline code block"
    },
    %{
      input: "```\ncode block\n```",
      html: "<pre><code>code block</code></pre>",
      content: "code block"
    },
    %{
      input: """
      ```html
      <div>
        nested
        <span>html</span>
      </div>
      ```
      """,
      html: """
      <pre><code class="html language-html">&lt;div&gt;
        nested
        &lt;span&gt;html&lt;/span&gt;
      &lt;/div&gt;</code></pre>
      """,
      content: "nested\n  html"
    },
    %{
      input: """
      ```elixir
      defmodule Foo do
        def bar, do: :baz
      end
      ```
      """,
      html: """
      <pre><code class="elixir language-elixir">defmodule Foo do
        def bar, do: :baz
      end</code></pre>
      """,
      content: "defmodule Foo do\n  def bar, do: :baz\nend"
    },
    %{
      input: """
      ```elixir
      iex> IO.inspect("Hello World!")
      ```
      """,
      html:
        "<pre><code class=\"elixir language-elixir\">iex&gt; IO.inspect(\"Hello World!\")</code></pre>",
      content: "iex> IO.inspect(\"Hello World!\")"
    },
    %{
      input: "`inline code block full http://link.com?foo=bar`",
      html:
        "<p>\n<code class=\"inline\">inline code block full http://link.com?foo=bar</code></p>",
      content: "inline code block full http://link.com?foo=bar"
    },
    %{
      input: "`inline code block relative /link?foo=bar`",
      html: "<p>\n<code class=\"inline\">inline code block relative /link?foo=bar</code></p>",
      content: "inline code block relative /link?foo=bar"
    },
    %{
      input: "```\ncode block full http://link.com?foo=bar\n```",
      html: "<pre><code>code block full http://link.com?foo=bar</code></pre>",
      content: "code block full http://link.com?foo=bar"
    },
    %{
      input: "```\ncode block relative /link?foo=bar\n```",
      html: "<pre><code>code block relative /link?foo=bar</code></pre>",
      content: "code block relative /link?foo=bar"
    },
    %{
      input: """
      <button type="button">buttons</button>
      are sanitized
      """,
      html: "buttons\n<p>\nare sanitized</p>",
      content: "buttons\n\nare sanitized"
    },
    %{
      input: """
      ```html
      <button type="button">buttons</button>
      are sanitized, but not inside a code tag
      ```
      """,
      html:
        "<pre><code class=\"html language-html\">&lt;button type=\"button\"&gt;buttons&lt;/button&gt;\nare sanitized, but not inside a code tag</code></pre>",
      content: "buttons\nare sanitized, but not inside a code tag"
    },
    %{
      input: "regular script <script>alert('attack')</script>",
      html: "<p>\nregular script &lt;script&gt;alert('attack')&lt;/script&gt;</p>",
      content: "regular script alert('attack')"
    },
    %{
      snippet_description: "does not allow inputs or forms to be rendered as html",
      input: "<form><input name='email' required /></form>",
      html: "",
      content: ""
    },
    %{
      snippet_description:
        "allows HTML5 elements (such as fieldset and legend) and forms as part of codeblocks",
      input:
        "```html\n<form name='login'>\n<fieldset>\n<legend>Email</legend>\n<input type='email' name='email' required />\n</fieldset>\n<div>\n<input type='submit' value='login' />\n<button type='button' id='validate'>\nvalidate\n</button>\n</div>\n</form>\n```",
      html:
        "<pre><code class=\"html language-html\">&lt;form name='login'&gt;\n&lt;fieldset&gt;\n&lt;legend&gt;Email&lt;/legend&gt;\n&lt;input type='email' name='email' required /&gt;\n&lt;/fieldset&gt;\n&lt;div&gt;\n&lt;input type='submit' value='login' /&gt;\n&lt;button type='button' id='validate'&gt;\nvalidate\n&lt;/button&gt;\n&lt;/div&gt;\n&lt;/form&gt;</code></pre>",
      content: "Email\n\n\n\n\n\nvalidate"
    }
  ]

  describe "to_html/1" do
    for case <- @to_html_data do
      @input Map.get(case, :input)
      @html Map.get(case, :html)
      @test_context Map.get(case, :snippet_description, inspect(@input))

      test "converts markdown '#{@test_context}' into html live" do
        assert Markdown.to_html_live(@input) == String.trim(@html)
      end

      test "live and cached produce same value for '#{@test_context}'" do
        assert Markdown.to_html_live(@input) == Markdown.to_html(@input)
      end
    end
  end

  describe "to_content/1" do
    for case <- @to_html_data do
      @input Map.get(case, :input)
      @content Map.get(case, :content)
      @test_context Map.get(case, :snippet_description, inspect(@input))

      test "gests content out of markdown '#{@test_context}'" do
        assert Markdown.to_content(@input) == String.trim(@content)
      end
    end
  end
end
