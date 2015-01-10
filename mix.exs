defmodule Plug.AccessLog.Mixfile do
  use Mix.Project

  def project do
    [ app:           :plug_accesslog,
      name:          "Plug.AccessLog",
      source_url:    "https://github.com/mneudert/plug_accesslog",
      version:       "0.0.1",
      elixir:        "~> 1.0",
      deps:          deps(Mix.env),
      docs:          [ readme: "README.md", main: "README" ],
      test_coverage: [ tool: ExCoveralls ]]
  end

  def application do
    [ mod: { Plug.AccessLog.Application, [] } ]
  end

  def deps(:docs) do
    deps(:prod) ++
      [ { :earmark, "~> 0.1" },
        { :ex_doc,  "~> 0.7" } ]
  end

  def deps(:test) do
    deps(:prod) ++
      [ { :dialyze,     "~> 0.1" },
        { :excoveralls, "~> 0.3" } ]
  end

  def deps(_) do
    [ { :cowboy, "~> 1.0", optional: true },
      { :plug,   "~> 0.9", optional: true } ]
  end
end
