defmodule BypassRoutes.Mixfile do
  use Mix.Project

  def project do
    [app: :bypass_routes,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:bypass, "~> 0.6.0"},

      {:poison, "~> 3.1", only: :test},
      {:httpoison, "~> 0.9", only: :test},
    ]
  end
end
