defmodule Expreso do
  alias Expreso.{Reducer, Evaluator}

  @moduledoc """
  A boolean expression parser and evaluator in Elixir.

  ## Basic types
  Expreso has five basic types: integers, floats, strings, list, and booleans.
  The following are some basic types:

  ```
  1           # integer
  1.0         # float
  true        # boolean
  'hello'     # string
  (1, 2, 3)   # list
  ```

  ## Operators

    * Arithmetic
      `+`, `-`, `/`, `*`

    * Comparisons
      `>`, `>=`, `<`, `<=`, `=`, `!=`

    * Boolean
      `not`, `in`, `and`, `or`

  """

  @doc """
  Evaluates the given `expr`.
  """
  @spec eval(expr :: String.t | charlist) :: {:ok, result::boolean} | {:error, error::map}
  @spec eval(expr :: String.t | charlist, props :: map) :: {:ok, result::boolean} | {:error, error::map}
  def eval(expr), do: eval(expr, %{})
  def eval(expr, props) do
    with {:ok, tree} <- parse(expr) do
      Reducer.reduce(tree, &Evaluator.eval(&1, props))
    end
  end

  @doc """
  Parses the given `expr` to a syntax tree.
  """
  @spec parse(expr :: String.t | charlist) :: {:ok, tree::tuple} | {:error, error::map}
  def parse(expr) do
    with {:ok, tokens} <- lex(expr) do
      :expreso_parser.parse(tokens)
    end
  end

  @doc """
  Tokenizes the given `expr` to a tokens list.
  """
  @spec lex(expr :: String.t | charlist) :: {:ok, tokens::list}
  def lex(expr) when is_binary(expr) do
    expr |> to_charlist() |> lex()
  end

  def lex(expr) do
    {:ok, tokens, _} = expr |> :expreso_lexer.string()
    {:ok, tokens}
  end

  @doc """
  Lists all the variables in the given `expr`.
  """
  @spec variables(expr :: String.t | charlist) :: {:ok, variables::list}
  def variables(expr) do
    with {:ok, tokens} <- lex(expr),
         {:ok, _tree}  <- :expreso_parser.parse(tokens) do
      result = tokens
        |> Enum.filter(&elem(&1, 0) == :var)
        |> Enum.map(&elem(&1, 2))
        |> Enum.uniq()
      {:ok, result}
    end
  end
end
