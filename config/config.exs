use Mix.Config

if Mix.env() == :test do
  config :plug_accesslog, :wal, flush_interval: 10

  config :plug, :validate_header_keys_during_test, true
end
