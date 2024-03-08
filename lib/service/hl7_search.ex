defmodule HL7.Search do
  import Plug.Conn
  def search(conn,_base,qualifier) do
#      :io.format 'POST/2:#{qualifier}', []
      send_resp(conn, 200, HL7.Service.encode(%{"qualifier" => qualifier}))
  end
  def post3(conn,_base,resource,qualifier) do
#      :io.format 'POST/3:#{resource}/#{qualifier}', []
      send_resp(conn, 200, HL7.Service.encode(%{"resource" => resource, "qualifier" => qualifier}))
  end
end
