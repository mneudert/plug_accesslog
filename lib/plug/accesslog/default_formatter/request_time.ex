defmodule Plug.AccessLog.DefaultFormatter.RequestTime do
  @moduledoc """
  Creates a formatted request time string.
  """

  use Timex

  @doc """
  Appends to log output.
  """
  @spec append(String.t, Plug.Conn.t) :: String.t
  def append(message, conn), do: message <> request_time(conn)

  defp request_time(conn) do
    format_string = "[%d/%b/%Y:%H:%M:%S %z]"

    conn.private[:plug_accesslog]
    |> Map.get(:local_time)
    |> Timex.format!(format_string, :strftime)
  end
end
