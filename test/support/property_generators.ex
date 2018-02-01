defmodule Expreso.PropertyGenerators do
  @moduledoc """
  Custom generators for ExUnit Property tests
  """
  use ExUnitProperties

  @doc "Generates a list of any given type and a value that could be in that list"
  def one_of_values_in_list(types) do
    types
    |> one_of()
    |> (&{&1, nonempty(list_of(&1))}).()
  end

    @doc "Generate either a float or a integer"
    def number do
      one_of([
          integer(),
          float()
        ])
    end

  @doc "Generate possible keyword that could comprise a node of an ast"
  def keyword do
    one_of([
        string(:ascii),
        string(:alphanumeric),
        integer(),
        float()
      ])
  end

  @doc "Key a list of keywords that omit the given values"
  def invalid_keyword_list(valid_key_words) do
    list_of(
      filter(
        keyword(),
        fn x -> x not in valid_key_words end
      )
    )
  end
end
