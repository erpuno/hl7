defmodule HL7.Meta do
   import Plug.Conn
  def meta(conn) do
       :io.format 'HL7/$meta', []
       conn |> Plug.Conn.put_resp_content_type("application/json") |>
       send_resp(200,
         HL7.Service.encode([
         %{ "resourceType" => "Parameters",
            "parameters" => [
               %{ "name" => "return",
                  "valueMeta" => %{
                  "profile" => :lists.map(fn x -> "https://hl7.erp.uno/" <> :erlang.iolist_to_binary(x) end, :filelib.wildcard('schema/*')),
                  "security" => [%{"system" => "https://hl7.erp.uno/CodeSystem/v4", "code" => "N", "display" => "normal" }],
                  "tag" => [%{"system" => "https://hl7.erp.uno/tag/", "code" => "N", "display" => "normal" }]}
                }]
          }]))
  end
end
