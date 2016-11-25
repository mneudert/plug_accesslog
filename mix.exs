defmodule Plug.AccessLog.Mixfile do
  use Mix.Project

  @url_github "https://github.com/mneudert/plug_accesslog"

  def project do
    [ app:     :plug_accesslog,
      name:    "Plug.AccessLog",
      version: "0.14.0",
      elixir:  "~> 1.3",
      deps:    deps(),

      build_embedded:  Mix.env == :prod,
      start_permanent: Mix.env == :prod,

      preferred_cli_env: [
        coveralls:          :test,
        'coveralls.detail': :test,
        'coveralls.travis': :test
      ],

      description:   "Plug for writing access logs",
      docs:          docs(),
      package:       package(),
      test_coverage: [ tool: ExCoveralls ] ]
  end

  def application do
    [ applications: [ :logger, :timex ],
      mod:          { Plug.AccessLog.Application, [] } ]
  end

  defp deps do
    [ { :ex_doc, ">= 0.0.0", only: :dev },

      { :excoveralls, "~> 0.5", only: :test },

      { :timex,  "~> 3.0" },

      { :cowboy, "~> 1.0", optional: true },
      { :plug,   "~> 1.0", optional: true } ]
  end

  defp docs do
    [ extras:     [ "CHANGELOG.md", "README.md" ],
      main:       "readme",
      source_ref: "v0.14.0",
      source_url: @url_github ]
  end

  defp package do
    %{ files:       [ "CHANGELOG.md", "LICENSE", "mix.exs", "README.md", "lib" ],
       licenses:    [ "Apache 2.0" ],
       links:       %{ "GitHub" => @url_github },
       maintainers: [ "Marc Neudert" ] }
  end
end
