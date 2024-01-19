defmodule HL7.Endpoint do
  use Plug.Router
  plug Plug.Logger
  plug :match
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug :dispatch
  forward "/v5", to: HL7.Router
  match _ do send_resp(conn, 404, "Not found!") end
end
