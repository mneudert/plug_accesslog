defmodule Plug.AccessLogTest do
  use ExUnit.Case, async: true
  use Plug.Test

  defmodule Logfiles do
    def logfile_agent, do: Path.expand("../logs/plug_accesslog_agent.log", __DIR__)
    def logfile_clf, do: Path.expand("../logs/plug_accesslog_clf.log", __DIR__)
    def logfile_clf_vhost, do: Path.expand("../logs/plug_accesslog_clf_vhost.log", __DIR__)
    def logfile_combined, do: Path.expand("../logs/plug_accesslog_combined.log", __DIR__)

    def logfile_combined_vhost,
      do: Path.expand("../logs/plug_accesslog_combined_vhost.log", __DIR__)

    def logfile_referer, do: Path.expand("../logs/plug_accesslog_referer.log", __DIR__)
  end

  defmodule Router do
    use Plug.Router

    plug Plug.AccessLog, format: :agent, file: Logfiles.logfile_agent()
    plug Plug.AccessLog, format: :clf, file: Logfiles.logfile_clf()
    plug Plug.AccessLog, format: :clf_vhost, file: Logfiles.logfile_clf_vhost()
    plug Plug.AccessLog, format: :combined, file: Logfiles.logfile_combined()
    plug Plug.AccessLog, format: :combined_vhost, file: Logfiles.logfile_combined_vhost()
    plug Plug.AccessLog, format: :referer, file: Logfiles.logfile_referer()

    plug :match
    plug :dispatch

    get "/", do: send_resp(conn, 200, "OK")
  end

  @opts Router.init([])
  @test_ref "http://www.example.com/previous_page"
  @test_ua "curl/7.35.0"

  setup_all do
    conn(:get, "/")
    |> put_req_header("referer", @test_ref)
    |> put_req_header("user-agent", @test_ua)
    |> Router.call(@opts)

    :timer.sleep(50)
    :ok
  end

  test ":agent format" do
    assert @test_ua = Logfiles.logfile_agent() |> File.read!() |> String.trim()
  end

  test ":clf format" do
    regex = ~r/127.0.0.1 - - \[.+\] "GET \/ HTTP\/1.1" 200 2/
    log = Logfiles.logfile_clf() |> File.read!() |> String.trim()

    assert Regex.match?(regex, log)
  end

  test ":clf_vhost format" do
    regex = ~r/www.example.com 127.0.0.1 - - \[.+\] "GET \/ HTTP\/1.1" 200 2/
    log = Logfiles.logfile_clf_vhost() |> File.read!() |> String.trim()

    assert Regex.match?(regex, log)
  end

  test ":combined format" do
    regex = ~r/127.0.0.1 - - \[.+\] "GET \/ HTTP\/1.1" 200 2 "#{@test_ref}" "#{@test_ua}"/
    log = Logfiles.logfile_combined() |> File.read!() |> String.trim()

    assert Regex.match?(regex, log)
  end

  test ":combined_vhost format" do
    regex =
      ~r/www.example.com 127.0.0.1 - - \[.+\] "GET \/ HTTP\/1.1" 200 2 "#{@test_ref}" "#{@test_ua}"/

    log = Logfiles.logfile_combined_vhost() |> File.read!() |> String.trim()

    assert Regex.match?(regex, log)
  end

  test ":referer format" do
    log = Logfiles.logfile_referer() |> File.read!() |> String.split("\n") |> List.first()
    res = "#{@test_ref} -> /"

    assert ^res = log
  end
end
