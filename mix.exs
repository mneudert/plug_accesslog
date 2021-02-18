defmodule Plug.AccessLog.MixProject do
  use Mix.Project

  @url_github "https://github.com/mneudert/plug_accesslog"

  def project do
    [
      app: :plug_accesslog,
      name: "Plug.AccessLog",
      version: "0.16.0-dev",
      elixir: "~> 1.7",
      deps: deps(),
      description: "Plug for writing access logs",
      dialyzer: dialyzer(),
      docs: docs(),
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test
      ],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :plug],
      mod: {Plug.AccessLog.Application, []}
    ]
  end

  defp dialyzer do
    [
      flags: [
        :error_handling,
        :race_conditions,
        :underspecs,
        :unmatched_returns
      ],
      plt_core_path: "plts",
      plt_file: {:no_warn, "plts/dialyzer.plt"}
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.13.0", only: :test, runtime: false},
      {:plug, "~> 1.6"},
      {:timex, "~> 3.0"}
    ]
  end

  defp docs do
    [
      extras: ["CHANGELOG.md", "README.md"],
      main: "readme",
      source_ref: "master",
      source_url: @url_github
    ]
  end

  defp package do
    %{
      files: ["CHANGELOG.md", "LICENSE", "mix.exs", "README.md", "lib"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => @url_github}
    }
  end
end
