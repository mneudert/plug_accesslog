# Changelog

## v0.8.0-dev

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
