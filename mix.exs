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
      source_url: @source_url,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [
        docs: :docs,
        "hex.publish": :docs
      ],
      docs: docs(),
      package: [
        description: "Req plugin to instrument requests with Telemetry events",
        licenses: ["MIT"],
        links: %{
          "GitHub" => @source_url
        }
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
      {:ex_doc, ">= 0.31.0", only: :docs},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
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
