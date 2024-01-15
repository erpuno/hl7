defmodule Routes.Base do
  defmacro __using__([]) do
    quote do
      use Plug.Router

      plug :match
      plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
      plug :dispatch

      defp send(conn, code, data) when is_integer(code) do
        conn
          |> Plug.Conn.put_resp_content_type("application/json")
          |> send_resp(code, Jason.encode!(data))
      end

    end
  end
end
