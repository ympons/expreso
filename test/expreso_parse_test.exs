defmodule Expreso.ParserTest do
  use ExUnit.Case
  doctest Expreso

  test "tokenize an expression" do
    str = "a = 22"
    exp = [{:var, 1, "a"}, {:eq_op, 1, :=}, {:number, 1, 22}]
    assert {:ok, exp} == Expreso.lex(str)
  end

  test "tokenize a string expression" do
    str = "a = 'Yaismel'"
    exp = [{:var, 1, "a"}, {:eq_op, 1, :=}, {:string, 1, "Yaismel"}]
    assert {:ok, exp} == Expreso.lex(str)
  end

  test "tokenize an expression with float" do
    str = "a = 0.5"
    exp = [{:var, 1, "a"}, {:eq_op, 1, :=}, {:number, 1, 0.5}]
    assert {:ok, exp} == Expreso.lex(str)
  end

  test "tokenize an expression with module operator" do
    str = "a mod 1 = 22"
    exp = [
      {:var, 1, "a"},
      {:mult_op, 1, :mod},
      {:number, 1, 1},
      {:eq_op, 1, :=},
      {:number, 1, 22}
    ] 
    assert {:ok, exp} == Expreso.lex(str)
  end

  test "parse an expression" do
    str = "a = 22"
    exp = {:binary_expr, {:eq_op, :=},
            {:var, "a"}, 
            {:number, 22}}
    assert {:ok, exp} == Expreso.parse(str)
  end

  test "parse another expression" do
    str = "a + 1 >= 5 and b in (5, 11) and (c not in (3, 4))"
    exp = {:binary_expr, :and_op, 
            {:binary_expr, :and_op, 
              {:binary_expr, {:comp_op, :>=}, 
                {:binary_expr, {:add_op, :+}, {:var, "a"}, {:number, 1}}, 
                {:number, 5}}, 
              {:binary_expr, :in_op, {:var, "b"}, [5, 11]}}, 
            {:binary_expr, :not_in_op, {:var, "c"}, [3, 4]}}
    assert {:ok, exp} == Expreso.parse(str)
  end

  test "parse an expression with in_op and sum" do
    str = "a + 1 in (3, 1, 2)"
    exp = {:binary_expr, :in_op, 
            {:binary_expr, {:add_op, :+}, {:var, "a"}, {:number, 1}}, [3, 1, 2]}
    assert {:ok, exp} == Expreso.parse(str)
  end

  test "parse boolean expression" do
    str = "true and 1 + 1 = 2"
    exp = {:binary_expr, :and_op,
            true,
            {:binary_expr, {:eq_op, :=},
              {:binary_expr, {:add_op, :+}, {:number, 1}, {:number, 1}},
              {:number, 2}}}
    assert {:ok, exp} == Expreso.parse(str)
  end
end