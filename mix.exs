defmodule BypassRoutes.Mixfile do
  use Mix.Project

  def project do
    [app: :bypass_routes,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
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

  defp description do
    """
    Provides an easy to way set up responses when using Bypass in your tests.
    """
  end

  defp package do
    # These are the default files included in the package
    [
      name: :bypass_routes,
      maintainers: ["Ciarán Walsh"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ciaran/bypass_routes"}
    ]
  end
end
