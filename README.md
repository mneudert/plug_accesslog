# Plug.AccessLog

Plug for writing access logs.


## Setup

To use the plug in your projects, edit your mix.exs file and add the project
as a dependency:

```elixir
defp deps do
  [ { :plug_accesslog, "~> 0.1" } ]
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
    format: :default,
    logfile: "/path/to/your/logs/access.log"

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


## Log Format

The default format is "%h \"%r\" %>s %b" and will gradually change
to the full [Common Log Format](http://en.wikipedia.org/wiki/Common_Log_Format)
once all required formatting options are supported.

The following formatting directives are available:

- `%b` - Size of response in bytes
- `%h` - Remote hostname
- `%r` - First line of HTTP request
- `%>s` - Response status code

**Note for %b**: To determine the size of the response the "Content-Length"
(exact case match required for now!) will be inspected and, if available,
returned unverified. If the header is not present the response body will be
inspected using `byte_size/1`.

**Note for %h**: The hostname will always be the ip of the client.

**Note for %r**: For now the http version is always logged as "HTTP/1.1",
regardless of the true http version.


## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
