defmodule HL7.Compartment do
  import Plug.Conn
  def compartment(conn,_base,compartment,id,qualifier) do
      :io.format 'POST/4:#{compartment}/#{qualifier}', []
      send_resp(conn, 200, HL7.Service.encode(%{"compartment" => compartment, "id" => id, "qualifier" => qualifier}))
  end
  def post5(conn,_base,compartment,id,resource,qualifier) do
      :io.format 'POST/5:#{compartment}/#{id}#{qualifier}', []
      send_resp(conn, 200, HL7.Service.encode(%{"compartment" => compartment, "resource" => resource,  "id" => id, "qualifier" => qualifier}))
  end
end
