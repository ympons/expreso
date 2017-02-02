defmodule Expreso.Mixfile do
  use Mix.Project

  def project do
    [app: :expreso,
     version: "0.0.1",
     elixir: "~> 1.3",
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end
  
  defp description do
    """
    Boolean expression parser and evaluator in Elixir.
    Tags: expreso, boolean, parse, parser, eval
    """
  end

  defp package do
    [name: :expreso,
     files: ["lib", "mix.exs", "README*", "LICENSE", "src"],
     maintainers: ["Yaismel Miranda"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/ympons/expreso"}]
  end
end
