# Expreso

An Elixir library for parsing and evaluating boolean expressions

## Installation

From [Hex](https://hex.pm/packages/expreso), the package can be installed as:

  1. Add `expreso` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:expreso, "~> 0.0.2"}]
    end
    ```

## Usage

```
Expreso.eval(expression, variables)
```

Parses and evaluates the provided expression. The variables can be supplied as a map in the `variables` parameter.

eg.
```
iex> Expreso.eval("a + 2 in (3, 1)", %{"a" => 1})
iex> {:ok, true}
```
