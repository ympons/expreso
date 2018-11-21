# Expreso [![Build Status](https://travis-ci.org/ympons/expreso.svg?branch=master)](https://travis-ci.org/ympons/expreso) [![Hex Version](https://img.shields.io/hexpm/v/expreso.svg)](https://hex.pm/packages/expreso)
An Elixir library for parsing and evaluating boolean expressions

## Installation

From [Hex](https://hex.pm/packages/expreso), the package can be installed as:

  1. Add `expreso` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:expreso, "~> 0.1.1"}]
    end
    ```

## Usage

```
Expreso.eval(expression, variables)
```

Parses and evaluates the provided expression. The variables can be supplied as a map in the `variables` parameter.

eg.
```
# Evaluate if a + 2 is between 3 and 1
iex> Expreso.eval("a + 2 in (3, 1)", %{"a" => 1})
iex> {:ok, true}

# Check if the key "test" is "works"
iex> Expreso.eval("test = 'works'", %{"test" => "works"})
iex> {:ok, true}

# Check if the key "test" is "works" or "great"
iex> Expreso.eval("test = 'works' or test = 'great'", %{"test" => "great"})
iex> {:ok, true}

# Evaluate an expression with not_in_op and sum
iex> Expreso.eval("10 + 2 not in (3, 1)")
iex> {:ok, true}

# Evaluate an expression with and_logic
iex> Expreso.eval("a + 2 in (2, 3) and 1 + 1 >= 2", %{"a" => 1})
iex> {:ok, true}

# Evaluate an expression with string
iex> Expreso.eval("a = 'Hello' and b != 'World' and 1 + 1 = 2", %{"a" => "Hello", "b" => ""})
iex> {:ok, true}

# Evaluate an expression with an array variable
iex> Expreso.eval("a in b", %{"a" => 1, "b" => [2, 1]})
iex> {:ok, true}

# Evaluate another expression with an array variable
iex> Expreso.eval("a not in b", %{"a" => 1, "b" => [2, 1]})
iex> {:ok, false}

# Evaluate an expression using not operator
iex> Expreso.eval("not 1 > 1 + a", %{"a" => 2})
iex> {:ok, true}
```
