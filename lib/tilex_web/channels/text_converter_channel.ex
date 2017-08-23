defmodule Tilex.TextConverterChannel do
  use Phoenix.Channel

  alias Tilex.Markdown

  def join("text_converter", _message, socket) do
    {:ok, socket}
  end

  def handle_in("convert", %{"markdown" => markdown}, socket) do
    html = Markdown.to_html_live(markdown)

    push socket, "converted", %{html: html}
    {:noreply, socket}
  end
end
