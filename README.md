# Plug.AccessLog

Plug for writing access logs.

## Setup

To use the plug in your projects, edit your mix.exs file and add the project as a dependency:

```elixir
defp deps do
  [
    # ...
    {:plug_accesslog, "~> 0.15.0"},
    # ...
  ]
end
```

## Usage

Add the plug to your plug pipeline/router:

```elixir
defmodule AppRouter do
  use Plug.Router

  plug Plug.AccessLog,
    format: :clf,
    file: "/path/to/your/logs/access.log"

  plug :match
  plug :dispatch

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
```

__Note__: The usage examples apply to a usecase where your are using `plug` directly without any framework. Using the `plug Plug.AccessLog` line in a framework based on `plug` should be no problem. Please refer to your frameworks individual documentation or source to find a suitable place.

### WAL Configuration

All log messages that will be written to a file are collected in a WAL process
before actual writing. The messages will be fetched in a configurable interval
to be written to the logfiles:

```elixir
config :plug_accesslog,
  :wal,
    flush_interval: 100
```

The time is configured as "milliseconds between writing and flushing". The default value is `100` milliseconds.

### Custom Formatters

If you want to extend the formatting capabilities or replace existing ones you can define a custom formatter pipeline to use:

```elixir
defmodule CustomFormatter do
  @behaviour Plug.AccessLog.Formatter

  def format(format, conn) do
    # manipulate to your liking
    format
  end
end

defmodule Router do
  use Plug.Router

  plug Plug.AccessLog,
    format: :clf,
    formatters: [CustomFormatter, Plug.AccessLog.DefaultFormatter],
    file: "/path/to/your/logs/access.log"
end
```

If you do not configure a list of formatters only the `DefaultFormatter` will be used. If you define an empty list then no formatting will take place.

All formatters are called in the order they are defined in.

### File Configuration

There are two ways to define the file you want log entries to be written to:

```elixir
defmodule Router do
  use Plug.Router

  plug Plug.AccessLog, file: "/static/configuration.log"
  plug Plug.AccessLog, file: {:system, "SYS_ENV_VAR_WITH_FILE_PATH"}
  plug Plug.AccessLog, file: {:system, "SYS_ENV_VAR", "/path/to/default.log"}
end
```

### Do Not Log Filter

To filter the requests before logging you can configure a "do not log" filter function:

```elixir
defmodule LogFilter do
  def dontlog?(%{request_path: "/favicon.ico"}), do: true
  def dontlog?(_conn), do: false
end

defmodule Router do
  use Plug.Router

  plug Plug.AccessLog,
    dontlog: &LogFilter.dontlog?/1,
    format: :clf,
    file: "/path/to/your/logs/access.log"
end
```

If the function you pass to the plug returns `true` the request will not be logged.

### Logging Functions

To have the parsed log message sent to a logging function instead of writing it to a file you can configure a logging function:

```elixir
defmodule InfoLogger do
  def log(msg), do: Logger.log(:info, msg)
end

defmodule Router do
  use Plug.Router

  plug Plug.AccessLog,
    format: :clf,
    fun: &InfoLogger.log/1
end
```

If a logging function is configured the configured file (if any) will be ignored.

## Log Format

The default format is [CLF](http://en.wikipedia.org/wiki/Common_Log_Format).

### Available formats

Besides a self defined format you can use one of the predefined aliases:

```
:agent
> %{User-Agent}i
> curl/7.35.0

:clf
> %h %l %u %t "%r" %>s %b
> 127.0.0.1 - - [10/Jan/2015:14:46:18 +0100] "GET / HTTP/1.1" 200 31337

:clf_vhost
> %v %h %l %u %t "%r" %>s %b
> www.example.com 127.0.0.1 - - [10/Jan/2015:14:46:18 +0100] "GET / HTTP/1.1" 200 31337

:combined
> %h %l %u %t "%r" %>s %b "%{Referer}i" "%{User-Agent}i"
> 127.0.0.1 - - [22/Jan/2015:19:33:58 +0100] "GET / HTTP/1.1" 200 2 "http://www.example.com/previous_page" "curl/7.35.0"

:combined_vhost
> %v %h %l %u %t "%r" %>s %b "%{Referer}i" "%{User-Agent}i"
> www.example.com 127.0.0.1 - - [22/Jan/2015:19:33:58 +0100] "GET / HTTP/1.1" 200 2 "http://www.example.com/previous_page" "curl/7.35.0"

:referer
> %{Referer}i -> %U
> http://www.example.com/previous_page -> /
```

For more details about each formatting token and potential modifications please refer to the `Plug.AccessLog.DefaultFormatter` module.

## Benchmarking

A small utility script is provided to check how long it might take to process requests and write the log messages to your disk:

```shell
mix run utils/bench.exs
```

This call will send of a total of 10k requests and wait for them to be written to the disk.

Looking at the data written to `utils/bench.log` might give a hint at what overhead the log writing is introducing. As with all "benchmarks" of any kind: take the measurements with a pinch of salt and run them in dozens of different conditions yourself.

## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
