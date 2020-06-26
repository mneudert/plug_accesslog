defmodule Plug.AccessLog.DefaultFormatter.ResponseBytes do
  @moduledoc """
  Calculates response size in bytes.
  """

  import Plug.Conn

  @doc """
  Formats the log output.
  """
  @spec format(Plug.Conn.t(), String.t()) :: iodata
  def format(conn, fallback) do
    bytes =
      case get_resp_header(conn, "content-length") do
        [length | _] -> length
        _ -> conn |> body_length() |> to_string()
      end

    case bytes do
      "0" -> fallback
      bytes -> bytes
    end
  end

  defp body_length(%{resp_body: nil}), do: 0
  defp body_length(%{resp_body: body}) when is_binary(body), do: body |> byte_size()
  defp body_length(%{resp_body: body}), do: body |> to_string() |> byte_size()
end
