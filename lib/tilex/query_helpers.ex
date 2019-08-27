defmodule Tilex.QueryHelpers do
  defmacro between(field, left_bound, right_bound) do
    quote do
      fragment(
        "? between ? and ?",
        unquote(field),
        unquote(left_bound),
        unquote(right_bound)
      )
    end
  end

  defmacro matches?(field, regex) do
    quote do
      fragment("? ~ ?", unquote(field), unquote(regex))
    end
  end

  defmacro greatest(value1, value2) do
    quote do
      fragment("greatest(?, ?)", unquote(value1), unquote(value2))
    end
  end

  defmacro hours_since(timestamp) do
    quote do
      fragment(
        "extract(epoch from (current_timestamp - ?)) / 3600",
        unquote(timestamp)
      )
    end
  end
end
