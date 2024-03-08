defmodule HL7.Delete do
  import Plug.Conn
  def delete(conn,_,type,id,spec) do
#      :io.format 'DELETE/3:#{type}#{id}/#{spec}', []
      send_resp(conn, 200, HL7.Service.encode(%{"type" => type, "id" => id, "spec" => spec}))
  end
end