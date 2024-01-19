defmodule HL7.Service do
   # Reference Implementation: http://hapi.fhir.org/
   import Plug.Conn

   def postRoot(conn), do: send_resp(conn, 200, [%{}])
   def postDiff(conn), do: send_resp(conn, 200, [%{}])
   def postExport(conn), do: send_resp(conn, 200, [%{}])
   def postMeta(conn), do: send_resp(conn, 200, [%{}])
   def reindex(conn), do: send_resp(conn, 200, [%{}])

   def root(conn), do: send_resp(conn, 200, [%{}])
   def metadata(conn), do: send_resp(conn, 200, [%{"resourceType" => "CapabilityStatement"}])
   def history(conn), do: send_resp(conn, 200, [%{}])
   def diff(conn), do: send_resp(conn, 200, [%{}])
   def export(conn), do: send_resp(conn, 200, %{"resourceType" => "CapabilityStatement"})
   def meta(conn), do:
       send_resp(conn, 200,
         %{ "resourceType" => "Parameters",
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
           })

   def get3(conn,base,type,id) do send_resp(conn, 200, %{"base" => base, "type" => type, "id" => id}) end
   def post2(conn,base,qualifier) do send_resp(conn, 200, %{"base" => base, "qualifier" => qualifier}) end
   def post3(conn,base,resource,qualifier) do send_resp(conn, 200, %{"base" => base, "resource" => resource, "qualifier" => qualifier}) end
   def post4(conn,base,compartment,id,qualifier) do send_resp(conn, 200, %{"base" => base, "compartment" => compartment, "id" => id, "qualifier" => qualifier}) end
   def post5(conn,base,compartment,id,resource,qualifier) do send_resp(conn, 200, %{"base" => base, "compartment" => compartment, "resource" => resource,  "id" => id, "qualifier" => qualifier}) end
   def put3(conn,base,type,id) do send_resp(conn, 200, %{"base" => base, "type" => type, "id" => id}) end
   def delete3(conn,base,type,id) do send_resp(conn, 200, %{"base" => base, "type" => type, "id" => id}) end
end
