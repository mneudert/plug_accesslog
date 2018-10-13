defmodule Plug.AccessLog.Mixfile do
  use Mix.Project

  @url_github "https://github.com/mneudert/plug_accesslog"

  def project do
    [
      app: :plug_accesslog,
      name: "Plug.AccessLog",
      version: "0.15.0-dev",
      elixir: "~> 1.5",
      deps: deps(),
      description: "Plug for writing access logs",
      docs: docs(),
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.travis": :test
      ],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :plug, :timex],
      mod: {Plug.AccessLog.App, []}
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test, runtime: false},
      {:plug, "~> 1.0", optional: true},
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
      links: %{"GitHub" => @url_github},
      maintainers: ["Marc Neudert"]
    }
  end
end
