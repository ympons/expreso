defmodule Expreso.Mixfile do
  use Mix.Project

  def project do
    [app: :expreso,
     version: "0.0.2",
     elixir: "~> 1.3",
     description: description(),
     elixirc_paths: elixirc_paths(Mix.env),
     package: package(),
     deps: deps()]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:mix_test_watch, "~> 0.1.1", only: :test},
      {:stream_data, "~> 0.1", only: :test},
    ]
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
