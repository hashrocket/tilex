defmodule Tilex.StructuredDataViewTest do
  use ExUnit.Case, async: true
  alias TilexWeb.StructuredDataView

  @ld_json_data [
    {%{}, "{}"},
    {%{foo: :bar}, "{\"foo\":\"bar\"}"},
    {%{foo: nil}, "{\"foo\":null}"},
    {%{foo: []}, "{\"foo\":[]}"},
    {%{foo: [1, "a"]}, "{\"foo\":[1,\"a\"]}"}
  ]

  describe "to_ld_json" do
    for {input, output} <- @ld_json_data do
      @input input
      @output output

      test "renders ld_json from data: '#{inspect(@input)}'" do
        assert StructuredDataView.to_ld_json(@input) == {:safe, @output}
      end
    end
  end
end
