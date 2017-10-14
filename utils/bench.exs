defmodule Plug.AccessLog.Bench do
  @moduledoc false

  defmodule Logfile do
    def path do
      [__DIR__, "bench.log"]
      |> Path.join()
      |> Path.expand()
    end
  end

  defmodule Router do
    use Plug.Router

    plug(Plug.AccessLog, file: Logfile.path())

    plug(:match)
    plug(:dispatch)

    get("/", do: send_resp(conn, 200, "OK"))
  end

  use Plug.Test

  @clients 10
  @requests 1000

  @entry_size byte_size(~s(127.0.0.1 - - [13/Mar/2017:14:57:57 +0100] "GET / HTTP/1.1" 200 2\n))
  @router_opts Router.init([])

  @doc false
  def run() do
    prepare()
    execute()

    {runtime, :ok} = :timer.tc(&wait/0)

    IO.puts("==> Time taken: #{div(runtime, 1000) / 1000}s <==")
    :ok
  end

  def execute() do
    for _ <- 1..@clients do
      Task.start(fn ->
        for _ <- 1..@requests do
          conn(:get, "/") |> Router.call(@router_opts)
        end
      end)
    end
  end

  defp prepare() do
    _ = File.rm(Logfile.path())
  end

  defp wait() do
    :timer.sleep(250)
    wait(0)
  end

  defp wait(count) when count >= @clients * @requests, do: :ok

  defp wait(count) do
    IO.puts("Processed events: #{count}")

    :timer.sleep(100)

    Logfile.path()
    |> File.stat!()
    |> Map.get(:size)
    |> Kernel.div(@entry_size)
    |> wait()
  end
end

Plug.AccessLog.Bench.run()
