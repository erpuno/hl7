defmodule HL7.Put do
  import Plug.Conn
  def put(conn,_,type,id,spec) do
      :io.format 'PUT/4:#{type}#{id}/#{spec}', []
      send_resp(conn, 200, HL7.Service.encode(%{"type" => type, "id" => id, "spec" => spec}))
  end
end
