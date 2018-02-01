defmodule Expreso.PropertyTest do
  use ExUnit.Case, async: false
  use ExUnitProperties

  import Expreso.PropertyGenerators

  @valid_keywords [
    "*",
    "/",
    "+",
    "-",
    "=",
    "!=",
    ">",
    ">=",
    "<",
    "<=",
    "in",
    "not",
    "and",
    "or"
  ]

  defp eval_template(template, data \\ %{}) do
    {:ok, value} = Expreso.eval(template, data)
    value
  end

  def template_status(template, data \\ %{}) do
    try do
      {status, _value} = Expreso.eval(template, data)
      status
    rescue
      _ -> :error
    end
  end

  property "numerical comparison" do
    check all x <- number(),
              y <- number() do
      assert x < y == eval_template("x < y", %{"x" => x, "y" => y})
      assert x <= y == eval_template("x <= y", %{"x" => x, "y" => y})
      assert x > y == eval_template("x > y", %{"x" => x, "y" => y})
      assert x >= y == eval_template("x >= y", %{"x" => x, "y" => y})
      assert x == y == eval_template("x = y", %{"x" => x, "y" => y})
      assert x != y == eval_template("x != y", %{"x" => x, "y" => y})
    end

    check all x <- number(),
              y <- number() do
      assert x < y == eval_template("#{x} < #{y}")
      assert x <= y == eval_template("#{x} <= #{y}")
      assert x > y == eval_template("#{x} > #{y}")
      assert x >= y == eval_template("#{x} >= #{y}")
      assert x == y == eval_template("#{x} = #{y}")
      assert x != y == eval_template("#{x} != #{y}")
    end
  end

  property "string equality" do
    check all x <- string(:alphanumeric),
              y <- string(:alphanumeric) do
      assert x == y == eval_template("x = y", %{"x" => x, "y" => y})
      assert x != y == eval_template("x != y", %{"x" => x, "y" => y})
    end
  end

  property "list contains" do
    check all {x, y} <- one_of_values_in_list([string(:alphanumeric), number()]) do
      assert x in y == eval_template("x in y", %{"x" => x, "y" => y})
      assert x not in y == eval_template("x not in y", %{"x" => x, "y" => y})
    end
  end

  property "boolean operators on numerical" do
    check all [x, y, w, z] <- one_of([
      list_of(string(:alphanumeric), length: 4),
      list_of(number(), length: 4)
    ]) do
      data = %{"x" => x, "y" => y, "w" => w, "z" => z}

      assert (x == y and w == z) == eval_template("x = y and w = z", data)
      assert (x == y or w == z) == eval_template("x = y or w = z", data)

      assert (x == w and y == z) == eval_template("x = w and y = z", data)
      assert (x == w or y == z) == eval_template("x = w or y = z", data)

      assert (x == y) == eval_template("x = y and y = x", data)
      assert (x == y) == eval_template("x = y or 1 = 2", data)
      assert (x == y) == eval_template("1 = 2 or x = y", data)
    end
  end

  property "numerical variables equivalent to litterals" do
    check all x <- number(),
              y <- number() do
      assert eval_template("x = y", %{"x" => x, "y" => y}) == eval_template("#{x} = #{y}")
    end
  end

  property "boolean variables equivalent to litterals" do
    check all x <- boolean() do
      assert eval_template("x and x", %{"x" => x}) == eval_template("#{x} and #{x}")
      assert eval_template("x or x", %{"x" => x}) == eval_template("#{x} or #{x}")
    end
  end

  property "invalid keywords" do
    check all lst <- invalid_keyword_list(@valid_keywords) do
      template = Enum.join(lst, " ")
      assert template_status(template) == :error
    end
  end

  property "boolean numerical evaluation equality" do
    check all x <- number(),
              y <- number() do
      values_equal = x == y
      assert eval_template("#{values_equal}") == eval_template("x = y", %{"x" => x, "y" => y})
    end
  end

  property "communicative" do
    check all x <- boolean(),
              y <- boolean() do
      assert eval_template("#{x} and #{y}") == eval_template("#{y} and #{x}")
      assert eval_template("#{x} or #{y}") == eval_template("#{y} or #{x}")
    end
  end

  property "associative" do
    check all x <- boolean(),
              y <- boolean(),
              z <- boolean() do
      assert eval_template("(#{x} and #{y}) and #{z}") == eval_template("#{x} and (#{y} and #{z})")
      assert eval_template("(#{x} or #{y}) or #{z}") == eval_template("#{x} or (#{y} or #{z})")
    end
  end

  property "distributive" do
    check all x <- boolean(),
              y <- boolean(),
              z <- boolean() do
      assert eval_template("#{x} and (#{y} or #{z})") == eval_template("(#{x} and #{y}) or (#{x} and #{z})")
      assert eval_template("#{x} or (#{y} and #{z})") == eval_template("(#{x} or #{y}) and (#{x} or #{z})")
    end
  end

  property "complement" do
    check all x <- boolean() do
      assert eval_template("#{x} and not #{x}") == false
      assert eval_template("#{x} or not #{x}") == true
    end
  end

  property "identity" do
    check all x <- number() do
      assert eval_template("x + 0 = x", %{"x" => x}) == true
      assert eval_template("x * 1 = x", %{"x" => x}) == true
    end

    check all x <- boolean() do
      assert eval_template("x and true", %{"x" => x}) == x
      assert eval_template("x or false", %{"x" => x}) == x
    end
  end

  property "DeMorgan’s Law" do
    check all x <- boolean(),
              y <- boolean() do
      assert eval_template("not (#{x} and #{y})") == eval_template("not #{y} or not #{x}")
      assert eval_template("not (#{x} or #{y})") == eval_template("not #{y} and not #{x}")
    end
  end
end
