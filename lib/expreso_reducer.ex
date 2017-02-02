defmodule Expreso.Reducer do
  @moduledoc """
  Provides features to reduce the AST.
  """

  def reduce({:binary_expr, op, a, b}, func) do
    with {:ok, a} = reduce(a, func),
         {:ok, b} = reduce(b, func) do
      func.({:binary_expr, op, a, b})       
    end
  end

  def reduce({:unary_expr, op, a}, func) do
    with {:ok, a} = reduce(a, func) do
      func.({:unary_expr, op, a})
    end
  end

  def reduce({type, value}, func) when type in [:number, :string, :var] do 
    func.({type, value})
  end

  def reduce(other, func) when is_list(other) or other in [true, false] do 
    func.(other)
  end
end