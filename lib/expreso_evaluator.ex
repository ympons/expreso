defmodule Expreso.Evaluator do
  @moduledoc """
  Provides features for evaluating the AST.
  """

  def eval({:binary_expr, {_op_type, op}, a, b}, _)
    when is_number(a) and is_number(b) do

    result = case op do
      :*  -> a * b
      :/  -> a / b
      :+  -> a + b
      :-  -> a - b
      :=  -> a == b
      :!= -> a != b
      :>  -> a >  b
      :>= -> a >= b
      :<  -> a <  b
      :<= -> a <= b
    end
    {:ok, result}
  end

  def eval({:binary_expr, {_op_type, op}, a, b}, _)
    when is_binary(a) and is_binary(b) do

    result = case op do
      :=  -> a == b
      :!= -> a != b
      # TODO: handle other operators, maybe string concatenation
    end
    {:ok, result}
  end

  def eval({:binary_expr, {_op_type, op}, a, b}, _)
    when is_boolean(a) and is_boolean(b) do

    result = case op do
      :=  -> a == b
      :!= -> a != b
    end
    {:ok, result}
  end

  def eval({type, value}, _) when type in [:number, :string], do: {:ok, value}
  def eval(boolean, _) when boolean in [true, false], do: {:ok, boolean}
  def eval(list, _) when is_list(list), do: {:ok, list}

  def eval({:var, variable}, props) do
    case Map.get(props, variable, nil) do
      nil -> {:error, "variable \"#{variable}\" not provided in: #{inspect props}"}
      value -> {:ok, value}
    end
  end

  def eval({:unary_expr, :not_op, a}, _)
    when is_boolean(a), do: {:ok, !a}

  def eval({:binary_expr, :in_op, a, list}, _)
    when is_list(list), do: {:ok, Enum.member?(list, a)}

  def eval({:binary_expr, :not_in_op, a, list}, _)
    when is_list(list), do: {:ok, !Enum.member?(list, a)}

  def eval({:binary_expr, :and_op, a, b}, _)
    when is_boolean(a) and is_boolean(b), do: {:ok, a and b}

  def eval({:binary_expr, :or_op, a, b}, _)
    when is_boolean(a) and is_boolean(b), do: {:ok, a or b}

  def eval(expr, _scope), do: {:error, "cannot perform evaluation #{inspect expr}"}
end
