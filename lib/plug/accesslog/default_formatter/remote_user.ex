defmodule Plug.AccessLog.DefaultFormatter.RemoteUser do
  @moduledoc """
  Determines remote user.
  """

  import Plug.Conn

  @doc """
  Formats the log output.
  """
  @spec format(Plug.Conn.t()) :: iodata
  def format(conn) do
    with [<<"Basic ", credentials::binary>> | _] <- get_req_header(conn, "authorization"),
         {:ok, user_pass} <- Base.decode64(credentials),
         [user, _] <- String.split(user_pass, ":") do
      user
    else
      _ -> "-"
    end
  end
end
