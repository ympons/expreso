defmodule Expreso.PropertyGenerators do
  @moduledoc """
  Custom generators for ExUnit Property tests
  """
  use ExUnitProperties

  @doc "Generates a float greater than or equal to 0"
  def abs_float, do: map(float(), &abs/1)

  @doc """
  Generates a tuple containing a float
  and it's string representation without scientific notation
  greater than or equal to 0
  """
  def abs_float_exclude_scientific(precision \\ 20) do
    map(
      abs_float(),
      fn scientific_float ->
        binary_float = :erlang.float_to_binary(
          scientific_float,
          [:compact, {:decimals, precision}]
        )

        {scientific_float, binary_float}
      end
    )
  end

  @doc "Generates a negative integer"
  def negative_integer, do: map(positive_integer(), fn i -> i * -1 end)

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
