# Changelog

## v0.5.0 (dev)

- Allows logging to functions instead of files
- Properly ignores unopenable logfiles (i.e. "..")
- Recreates logfile if necessary (i.e. after moved by logrotate)

Additional formatting directives:

- `%%` - Percentage sign

## v0.4.1

- Properly handles charlist responses (@chvanikoff)
- Reopens logfile IO device if pid is not alive anymore (@chvanikoff)

## v0.4.0

- Provides "Agent Log Format" alias
- Provides "Combined Log Format" alias
- Provides "Combined Log Format with VHost" alias
- Provides "Referer Log Format" alias

## v0.3.0

- Logs username from basic authentication
- Provides access to vhost (domain) for logging
- Raises plug version requirement to "~> 0.10"

## v0.2.0

- Supports full [CLF](http://en.wikipedia.org/wiki/Common_Log_Format)

## v0.1.0

- Initial Release
