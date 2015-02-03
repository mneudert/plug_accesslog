defmodule Plug.AccessLog.Mixfile do
  use Mix.Project

  @url_docs "http://hexdocs.pm/plug_accesslog"
  @url_github "https://github.com/mneudert/plug_accesslog"

  def project do
    [ app:           :plug_accesslog,
      name:          "Plug.AccessLog",
      description:   "Plug for writing access logs",
      source_url:    @url_github,
      package:       package,
      version:       "0.5.0-dev",
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
    [ { :timex, "~> 0.13" },

      { :cowboy, "~> 1.0",  optional: true },
      { :plug,   "~> 0.10", optional: true } ]
  end

  def package do
    %{ contributors: [ "Marc Neudert", "Roman Chvanikoff" ],
       files:        [ "LICENSE", "mix.exs", "README.md", "lib" ],
       licenses:     [ "Apache 2.0" ],
       links:        %{ "Docs" => @url_docs, "Github" => @url_github }}
  end
end
