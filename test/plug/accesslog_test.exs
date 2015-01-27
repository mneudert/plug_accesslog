defmodule Plug.AccessLogTest do
  use ExUnit.Case, async: true
  use Plug.Test

  defmodule Logfiles do
    def logfile_clf do
      [ __DIR__, "../logs/plug_accesslog_clf.log" ]
      |> Path.join()
      |> Path.expand()
    end

    def logfile_clf_vhost do
      [ __DIR__, "../logs/plug_accesslog_clf_vhost.log" ]
      |> Path.join()
      |> Path.expand()
    end

    def logfile_combined do
      [ __DIR__, "../logs/plug_accesslog_combined.log" ]
      |> Path.join()
      |> Path.expand()
    end

    def logfile_combined_vhost do
      [ __DIR__, "../logs/plug_accesslog_combined_vhost.log" ]
      |> Path.join()
      |> Path.expand()
    end
  end

  defmodule Router do
    use Plug.Router

    plug Plug.AccessLog, format: :clf,            file: Logfiles.logfile_clf
    plug Plug.AccessLog, format: :clf_vhost,      file: Logfiles.logfile_clf_vhost
    plug Plug.AccessLog, format: :combined,       file: Logfiles.logfile_combined
    plug Plug.AccessLog, format: :combined_vhost, file: Logfiles.logfile_combined_vhost

    plug :match
    plug :dispatch

    get "/", do: send_resp(conn, 200, "OK")
  end

  @opts     Router.init([])
  @test_ref "http://www.example.com/previous_page"
  @test_ua  "curl/7.35.0"

  test "request writes configured log entries" do
    conn(:get, "/")
    |> put_req_header("Referer", @test_ref)
    |> put_req_header("User-Agent", @test_ua)
    |> Router.call(@opts)

    # format: :clf
    regex = ~r/127.0.0.1 - - \[.+\] "GET \/ HTTP\/1.1" 200 2/
    log   = Logfiles.logfile_clf |> File.read!() |> String.strip()

    assert Regex.match?(regex, log)

    # format: :clf_vhost
    regex = ~r/www.example.com 127.0.0.1 - - \[.+\] "GET \/ HTTP\/1.1" 200 2/
    log   = Logfiles.logfile_clf_vhost |> File.read!() |> String.strip()

    assert Regex.match?(regex, log)

    # format: :combined
    regex = ~r/127.0.0.1 - - \[.+\] "GET \/ HTTP\/1.1" 200 2 "#{ @test_ref }" "#{ @test_ua }"/
    log   = Logfiles.logfile_combined |> File.read!() |> String.strip()

    assert Regex.match?(regex, log)

    # format: :combined_vhost
    regex = ~r/www.example.com 127.0.0.1 - - \[.+\] "GET \/ HTTP\/1.1" 200 2 "#{ @test_ref }" "#{ @test_ua }"/
    log   = Logfiles.logfile_combined_vhost |> File.read!() |> String.strip()

    assert Regex.match?(regex, log)
  end
end
