defmodule HL7.Service do
   # Reference Implementation: http://hapi.fhir.org/
   import Plug.Conn

   def postRoot(conn), do: send_resp(conn, 200, Jason.encode!([%{}]))
   def postDiff(conn), do: send_resp(conn, 200, Jason.encode!([%{}]))
   def postExport(conn), do: send_resp(conn, 200, Jason.encode!([%{}]))
   def postMeta(conn), do: send_resp(conn, 200, Jason.encode!([%{}]))
   def reindex(conn), do: send_resp(conn, 200, Jason.encode!([%{}]))

   def root(conn), do: send_resp(conn, 200, Jason.encode!([%{}]))
   def metadata(conn), do: send_resp(conn, 200, Jason.encode!([%{"resourceType" => "CapabilityStatement"}]))
   def history(conn), do: send_resp(conn, 200, Jason.encode!([%{}]))
   def diff(conn), do: send_resp(conn, 200, Jason.encode!([%{}]))
   def export(conn), do: send_resp(conn, 200, Jason.encode!([%{"resourceType" => "CapabilityStatement"}]))
   def meta(conn) do
       :io.format 'HL7/$meta', []
       conn |> Plug.Conn.put_resp_content_type("application/json") |>
       send_resp(200,
         Jason.encode!([%{ "resourceType" => "Parameters",
            "parameters" => [
               %{ "name" => "return",
                  "valueMeta" => %{
                     "profile" => [
                       "https://ehealth.gov.ua/StrudctureDefinition/Person",
                       "https://ehealth.gov.ua/StrudctureDefinition/Patients",
                       "https://ehealth.gov.ua/StrudctureDefinition/Organization",
                       "https://ehealth.gov.ua/StrudctureDefinition/Location"
                      ],
                     "security" => [%{"system" => "https://ehealth.gov.ua/CodeSystem/v4", "code" => "N", "display" => "normal" }],
                     "tag" => [%{"system" => "https://ehealth.gov.ua/tag/", "code" => "N", "display" => "normal" }]
                   }
                } ]
           }])) end

   def get3(conn,base,type,id) do
       :io.format 'GET/3 #{base}/#{type}/#{id}', []
       send_resp(conn, 200, Jason.encode!([%{"base" => base, "type" => type, "id" => id}])) end
   def get2(conn,base,qualifier) do
       :io.format 'GET/2 #{base}/#{qualifier}', []
       send_resp(conn, 200, Jason.encode!([%{"base" => base, "qualifier" => qualifier}])) end
   def post2(conn,base,qualifier) do
       :io.format 'POST/2 #{base}/#{qualifier}', []
       send_resp(conn, 200, Jason.encode!(%{"base" => base, "qualifier" => qualifier})) end
   def post3(conn,base,resource,qualifier) do
       :io.format 'POST/3 #{base}/#{resource}/#{qualifier}', []
       send_resp(conn, 200, Jason.encode!(%{"base" => base, "resource" => resource, "qualifier" => qualifier})) end
   def post4(conn,base,compartment,id,qualifier) do
       :io.format 'POST/4 #{base}/#{compartment}/#{qualifier}', []
       send_resp(conn, 200, Jason.encode!(%{"base" => base, "compartment" => compartment, "id" => id, "qualifier" => qualifier})) end
   def post5(conn,base,compartment,id,resource,qualifier) do
       :io.format 'POST/5 #{base}/#{compartment}/#{id}#{qualifier}', []
       send_resp(conn, 200, Jason.encode!(%{"base" => base, "compartment" => compartment, "resource" => resource,  "id" => id, "qualifier" => qualifier})) end
   def put3(conn,base,type,id) do
       :io.format 'PUT/3 #{base}/#{type}#{id}', []
       send_resp(conn, 200, Jason.encode!(%{"base" => base, "type" => type, "id" => id})) end
   def delete3(conn,base,type,id) do
       :io.format 'DELETE/3 #{base}/#{type}#{id}', []
       send_resp(conn, 200, Jason.encode!(%{"base" => base, "type" => type, "id" => id})) end
end
