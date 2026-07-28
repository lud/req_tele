defmodule ReqTele.MixProject do
  use Mix.Project

  @name "ReqTele"
  @version "0.1.2"
  @source_url "https://github.com/lud/req_tele"

  def project do
    [
      app: :req_tele,
      name: @name,
      version: @version,
      description: "Req plugin to instrument requests with Telemetry events",
      source_url: @source_url,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: dialyzer(),
      docs: docs(),
      package: package()
    ]
  end

  def cli do
    [
      preferred_envs: [
        dialyzer: :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, "~> 0.6"},
      {:telemetry, "~> 1.0"},

      # Dev
      {:libdev, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:readmix, ">= 0.0.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp dialyzer do
    [
      flags: [:unmatched_returns, :error_handling, :unknown, :extra_return],
      list_unused_filters: true,
      plt_add_deps: :app_tree,
      plt_local_path: "_build/plts"
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end

  defp docs do
    [
      source_url: @source_url,
      main: "ReqTele",
      extras: [
        "README.md": [title: "Overview"],
        "CHANGELOG.md": [title: "Changelog"]
      ]
    ]
  end
end
