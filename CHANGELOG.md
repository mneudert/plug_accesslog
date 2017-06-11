# Changelog

## v0.15.0-dev

- Enhancements
    - System environment configuration can set an optional default value
      to be used if the environment variable is unset

## v0.14.0 (2016-11-25)

- Additional formatting directives
    - `%{VARNAME}e` - Environment variable contents

- Backwards incompatible changes
    - All modules of the `DefaultFormatter` have been changed to not append to
      a passed message anymore but return `iodata`. The public method has been
      renamed from `append` to `format` to reflect this change.

## v0.13.0 (2016-07-13)

- Backwards incompatible changes
    - Minimum required elixir version is now "~> 1.3"
    - Minimum required version of :timex raised to "~> 3.0"

## v0.12.0 (2016-06-25)

- Backwards incompatible changes
    - Minimum required elixir version is now "~> 1.2"
    - Minimum required erlang version is now "~> 18.0"

## v0.11.0 (2016-03-25)

- Enhancements
    - Logfiles can be configured using system environment variables
    - Logs are written in batches to the output file (configurable, default `100ms`)

- Backwards incompatible changes
    - `:local_time` is now internally stored as a `Timex.DateTime` struct
    - Minimum required version of :timex raised to "~> 2.0" ([#12](https://github.com/mneudert/plug_accesslog/pull/12))

## v0.10.0 (2016-01-06)

- Additional formatting directives
    - `%P` - The process ID that serviced the request
    - `%{UNIT}T` - Time taken to serve the request in the given UNIT

- Backwards incompatible changes
    - Minimum required version of :timex raised to "~> 1.0"

## v0.9.1 (2015-09-29)

- Enhancements
    - Application :tzdata (for recent :timex/:tzdata versions) is started automatically

- Backwards incompatible changes
    - Minimum required version of :timex raised to "~> 0.19"
    - Minimum required version of :tzdata raised to "=> 0.5.1"

## v0.9.0 (2015-08-15)

- Backwards incompatible changes
    - Minimum required version of :plug raised to "~> 1.0"

## v0.8.0 (2015-08-08)

- Backwards incompatible changes
    - Minimum required version of :plug raised to "~> 0.14"

## v0.7.0 (2015-07-19)

- Enhancements
    - Allows passing custom formatters
    - Errors when open logfiles are logged as errors using Logger
    - Log writing is now handled by a GenEvent handler to avoid crashing

- Additional formatting directives
    - `%a` - Remote IP-address
    - `%D` - Time taken to serve the request (microseconds)
    - `%M` - Time taken to serve the request (milliseconds)
    - `%q` - Query string (prepended with "?" or empty string)
    - `%T` - Time taken to serve the request (full seconds)
    - `%V` - Server name (canonical)

- Backwards incompatible changes
    - `Plug.AccessLog.Formatter` has been renamed to `Plug.AccessLog.DefaultFormatter`

## v0.6.0 (2015-05-23)

- Enhancements
    - Allows passing a dontlog-function to skip requests from logging
    - Dependencies not used in production builds are marked as optional

- Additional formatting directives
    - `%{VARNAME}C` - Cookie sent by the client
    - `%m` - Request method
    - `%{VARNAME}o` - Header line sent by the server

## v0.5.1 (2015-05-11)

- Bug fixes
    - Properly accesses headers using lowercase (@c-rack)

## v0.5.0 (2015-02-24)

- Enhancements
    - Allows logging to functions instead of files
    - Properly ignores unopenable logfiles (i.e. "..")
    - Recreates logfile if necessary (i.e. after moved by logrotate)

- Additional formatting directives
    - `%%` - Percentage sign
    - `%B` - Size of response in bytes. Outputs "0" when no bytes are sent.

## v0.4.1 (2015-02-03)

- Bug fixes
    - Properly handles charlist responses (@chvanikoff)
    - Reopens logfile IO device if pid is not alive anymore (@chvanikoff)

## v0.4.0 (2015-01-31)

- Enhancements
    - Provides "Agent Log Format" alias
    - Provides "Combined Log Format" alias
    - Provides "Combined Log Format with VHost" alias
    - Provides "Referer Log Format" alias

## v0.3.0 (2015-01-25)

- Enhancements
    - Logs username from basic authentication
    - Provides access to vhost (domain) for logging
    - Raises plug version requirement to "~> 0.10"

## v0.2.0 (2015-01-18)

- Enhancements
    - Supports full [CLF](http://en.wikipedia.org/wiki/Common_Log_Format)

## v0.1.0 (2015-01-15)

- Initial Release
