# Plug.AccessLog

Plug for writing access logs.


## Setup

To use the plug in your projects, edit your mix.exs file and add the project
as a dependency:

```elixir
defp deps do
  [ { :plug_accesslog, "~> 0.9" } ]
end
```

You should also update your applications to start the plug:

```elixir
def application do
  [ applications: [ :plug_accesslog ] ]
end
```


## Usage

The easiest way to use the plug is to add it to your existing router:

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

__Note__: The usage examples apply to a usecase where your are using `plug`
directly without any framework. Using the `plug Plug.AccessLog` line in a
framework based on `plug` should be no problem. Please refer to your frameworks
individual documentation or source to find a suitable place.

### Custom Formatters

If you want to extend the formatting capabilities or replace existing ones
you can define a custom formatter pipeline to use:

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
    formatters: [ CustomFormatter, Plug.AccessLog.DefaultFormatter ],
    file: "/path/to/your/logs/access.log"
end
```

If you do not configure a list of formatters only the `DefaultFormatter` will
be used. If you define an empty list then no formatting will take place.

All formatters are called in the order they are defined in.

### Do Not Log Filter

To filter the requests before logging you can configure a "do not log" filter
function:

```elixir
defmodule LogFilter do
  def dontlog?(conn), do: "/favicon.ico" == full_path(conn)
end

defmodule Router do
  use Plug.Router

  plug Plug.AccessLog,
    dontlog: &LogFilter.dontlog?/1,
    format: :clf,
    file: "/path/to/your/logs/access.log"
end
```

If the function you pass to the plug returns `true` the request will not be
logged.

### Logging Functions

To have the parsed log message sent to a logging function instead of writing
it to a file you can configure a logging function:

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

If a logging function is configured the configured file (if any) will be
ignored.


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

### Formatting directives

The following formatting directives are available:

- `%%` - Percentage sign
- `%a` - Remote IP-address
- `%b` - Size of response in bytes. Outputs "-" when no bytes are sent.
- `%B` - Size of response in bytes. Outputs "0" when no bytes are sent.
- `%{VARNAME}C` - Cookie sent by the client
- `%D` - Time taken to serve the request (microseconds)
- `%h` - Remote hostname
- `%{VARNAME}i` - Header line sent by the client
- `%l` - Remote logname
- `%m` - Request method
- `%M` - Time taken to serve the request (milliseconds)
- `%{VARNAME}o` - Header line sent by the server
- `%q` - Query string (prepended with "?" or empty string)
- `%r` - First line of HTTP request
- `%>s` - Response status code
- `%t` - Time the request was received in the format `[10/Jan/2015:14:46:18 +0100]`
- `%T` - Time taken to serve the request (full seconds)
- `%{UNIT}T` - Time taken to serve the request in the given UNIT
- `%u` - Remote user
- `%U` - URL path requested (without query string)
- `%v` - Server name
- `%V` - Server name (canonical)

**Note for %b and %B**: To determine the size of the response the
"Content-Length" will be inspected and, if available, returned
unverified. If the header is not present the response body will be
inspected using `byte_size/1`.

**Note for %h**: The hostname will always be the ip of the client (same as `%a`).

**Note for %l**: Always a dash ("-").

**Note for %r**: For now the http version is always logged as "HTTP/1.1",
regardless of the true http version.

**Note for %T**: Rounding happens, so "0.6 seconds" will be reported as "1 second".

**Note for %{UNIT}T**: Available units are `s` for seconds (same as `%T`),
`ms` for milliseconds (same as `M`) and `us` for microseconds (same as `%D`).

**Note for %V**: Alias for `%v`.

## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
