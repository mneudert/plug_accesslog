defmodule Plug.AccessLog.Bench do
  @moduledoc false

  defmodule Logfile do
    def path do
      [ __DIR__, "bench.log" ]
      |> Path.join()
      |> Path.expand()
    end
  end

  defmodule Router do
    use Plug.Router

    plug Plug.AccessLog, file: Logfile.path

    plug :match
    plug :dispatch

    get "/", do: send_resp(conn, 200, "OK")
  end


  use Plug.Test

  @opts Router.init([])


  @doc false
  def run() do
    prepare()
    execute()

    { runtime, :ok } = :timer.tc &wait/0

    IO.puts "==> Time taken: #{ runtime } ms <=="
    :ok
  end

  def execute() do
    for _ <- 1..10 do
      Task.start fn ->
        for _ <- 1..1000 do
          conn(:get, "/") |> Router.call(@opts)
        end
      end
    end
  end

  defp prepare() do
    _ = File.rm Logfile.path
  end

  defp wait(), do: wait(0)

  defp wait(count) when count >= 10000, do: :ok
  defp wait(count)  do
    IO.puts "Processed events: #{ count }"

    :timer.sleep(1000)

    Logfile.path
    |> File.read!
    |> String.split("\n")
    |> Enum.count()
    |> wait()
  end
end

Plug.AccessLog.Bench.run()
