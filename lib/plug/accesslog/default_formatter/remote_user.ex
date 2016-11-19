defmodule Plug.AccessLog.DefaultFormatter.RemoteUser do
  @moduledoc """
  Determines remote user.
  """

  import Plug.Conn

  @doc """
  Formats the log output.
  """
  @spec format(Plug.Conn.t) :: iodata
  def format(conn) do
    case get_req_header(conn, "authorization") do
      [<< "Basic ", credentials :: binary >>] -> get_user(credentials)
      _ -> "-"
    end
  end


  defp get_user(credentials) do
    try do
      case parse_credentials(credentials) do
        [ user, _pass ] -> user
        _               -> "-"
      end
    rescue
      _ -> "-"
    end
  end

  defp parse_credentials(credentials) do
    credentials
    |> Base.decode64!()
    |> String.split(":")
  end
end
