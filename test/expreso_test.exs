defmodule ExpresoTest do
  use ExUnit.Case
  doctest Expreso

  test "evaluate an expression" do
    str = "1 <= 1 + a"
    assert {:ok, true} == str |> Expreso.eval(%{"a" => 2})
  end

  test "evaluate an expression with in_op and sum" do
    str = "a + 2 in (3, 1)"
    assert {:ok, true} == str |> Expreso.eval(%{"a" => 1})
  end

  test "evaluate an expression with not_in_op and sum" do
    str = "10 + 2 not in (3, 1)"
    assert {:ok, true} == str |> Expreso.eval
  end

  test "evaluate an expression with and_logic" do
    str = "a + 2 in (2, 3) and 1 + 1 >= 2"
    assert {:ok, true} == str |> Expreso.eval(%{"a" => 1})
  end

  test "evaluate an expression with string" do
    str = "a = 'Hello' and b != 'World' and 1 + 1 = 2"
    assert {:ok, true} == str |> Expreso.eval(%{"a" => "Hello", "b" => ""})
  end

  test "evaluate an expression with an array variable" do
    str = "a in b"
    assert {:ok, true} == str |> Expreso.eval(%{"a" => 1, "b" => [2, 1]})
  end

  test "evaluate another expression with an array variable" do
    str = "a not in b"
    assert {:ok, false} == str |> Expreso.eval(%{"a" => 1, "b" => [2, 1]})
  end

  test "evaluate an expression using not operator" do
    str = "not 1 > 1 + a"
    assert {:ok, true} == str |> Expreso.eval(%{"a" => 2})
  end

  test "lists variables of the given expression" do
    str = "a + b > 2"
    assert {:ok, ["a", "b"]} == str |> Expreso.variables
  end
end