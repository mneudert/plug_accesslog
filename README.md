# Plug.AccessLog

Plug for writing access logs.


## Setup

To use the plug in your projects, edit your mix.exs file and add the project
as a dependency:

```elixir
defp deps do
  [ { :plug_accesslog, "~> 0.5" } ]
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
- `%b` - Size of response in bytes. Outputs "-" when no bytes are sent.
- `%B` - Size of response in bytes. Outputs "0" when no bytes are sent.
- `%{VARNAME}C` - Cookie sent by the client
- `%h` - Remote hostname
- `%{VARNAME}i` - Header line sent by the client
- `%l` - Remote logname
- `%m` - Request method
- `%{VARNAME}o` - Header line sent by the server
- `%r` - First line of HTTP request
- `%>s` - Response status code
- `%t` - Time the request was received in the format `[10/Jan/2015:14:46:18 +0100]`
- `%u` - Remote user
- `%U` - URL path requested (without query string)
- `%v` - Server name

**Note for %b and %B**: To determine the size of the response the
"Content-Length" will be inspected and, if available, returned
unverified. If the header is not present the response body will be
inspected using `byte_size/1`.

**Note for %h**: The hostname will always be the ip of the client.

**Note for %l**: Always a dash ("-").

**Note for %r**: For now the http version is always logged as "HTTP/1.1",
regardless of the true http version.


## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
