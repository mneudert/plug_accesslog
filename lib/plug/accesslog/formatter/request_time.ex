defmodule Plug.AccessLog.Formatter.RequestTime do
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
    request_date  = conn.private[:plug_accesslog] |> Date.from(:local)
    format_string = "[%d/%b/%Y:%H:%M:%S %z]"

    DateFormat.format!(request_date, format_string, :strftime)
  end
end
