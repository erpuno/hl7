defmodule HL7.Service do
   # Reference Implementation: http://hapi.fhir.org/
   import Plug.Conn

   def encode(x) do
       case  Jason.encode(x) do 
             {:ok, bin} -> bin <> "\n" 
             {:error, %Protocol.UndefinedError{description: _, protocol: _, value: {:error, %Xema.ValidationError{message: _, reason: err}}}} -> err <> "\n"
             {:error, %Xema.ValidationError{message: _, reason: err}} -> err <> "\n"
       end |> Jason.Formatter.pretty_print
   end

   def postRoot(conn), do: send_resp(conn, 200, encode([%{}]))
   def postDiff(conn), do: send_resp(conn, 200, encode([%{}]))
   def postExport(conn), do: send_resp(conn, 200, encode([%{}]))
   def postMeta(conn), do: send_resp(conn, 200, encode([%{}]))
   def reindex(conn), do: send_resp(conn, 200, encode([%{}]))

   def root(conn), do: send_resp(conn, 200, encode([%{}]))
   def metadata(conn), do: send_resp(conn, 200, encode([%{"resourceType" => "CapabilityStatement"}]))
   def history(conn), do: send_resp(conn, 200, encode([%{}]))
   def diff(conn), do: send_resp(conn, 200, encode([%{}]))
   def export(conn), do: send_resp(conn, 200, encode([%{"resourceType" => "CapabilityStatement"}]))
   def meta(conn) do
       :io.format 'HL7/$meta', []
       conn |> Plug.Conn.put_resp_content_type("application/json") |>
       send_resp(200,
         encode([%{ "resourceType" => "Parameters",
            "parameters" => [
               %{ "name" => "return",
             "valueMeta" => %{
               "profile" => [ "https://hl7.erp.uno/schema/Person.schema.json",
                              "https://hl7.erp.uno/schema/Patient.schema.json",
                              "https://hl7.erp.uno/schema/Organization.schema.json",
                              "https://hl7.erp.uno/schema/Location.schema.json"  ],
              "security" => [%{"system" => "https://hl7.erp.uno/CodeSystem/v4",
                                 "code" => "N",
                              "display" => "normal" }],
                   "tag" => [%{"system" => "https://hl7.erp.uno/tag/",
                                 "code" => "N",
                              "display" => "normal" }]}}]}])) end

   def get4(conn,base,type,id,spec) do
       :io.format 'GET/4 #{base}/#{type}/#{id}/#{spec}', []
       send_resp(conn, 200, encode([%{"base" => base, "type" => type, "id" => id, "spec" => spec}])) end
   def put4(conn,base,type,id,"$validate" = spec) do
       {:ok, body, conn} = Plug.Conn.read_body(conn, [])
       schema = HL7.Loader.loadSchema("#{type}") 
       obj = Jason.decode!(body)
       res = case Xema.validate(schema, obj) do
             :ok -> {%{message: "Object conforms to #{type} of R5 schema.", code: "success"},"success"}
             {:error, %Xema.ValidationError{message: msg, reason: err}} -> {%{message: msg, reason: err},"error"}
       end
       {message,verify} = res
       :io.format 'PUT/4 #{base}/#{type}#{id}/#{spec}: ~p (~pKiB)', [verify, :erlang.round(:erlang.size(body) / 1024)]
       send_resp(conn, 200, encode(%{"base" => base, "type" => type, "id" => Map.get(obj, "id", Map.get(obj, "$id", "")), "spec" => spec, "verify" => message})) end
   def put4(conn,base,type,id,spec) do
       :io.format 'PUT/4 #{base}/#{type}#{id}/#{spec}', []
       send_resp(conn, 200, encode(%{"base" => base, "type" => type, "id" => id, "spec" => spec})) end
   def delete4(conn,base,type,id,spec) do
       :io.format 'DELETE/3 #{base}/#{type}#{id}/#{spec}', []
       send_resp(conn, 200, encode(%{"base" => base, "type" => type, "id" => id, "spec" => spec})) end
   def get2(conn,base,qualifier) do
       :io.format 'GET/2 #{base}/#{qualifier}', []
       send_resp(conn, 200, encode([%{"base" => base, "qualifier" => qualifier}])) end
   def post2(conn,base,qualifier) do
       :io.format 'POST/2 #{base}/#{qualifier}', []
       send_resp(conn, 200, encode(%{"base" => base, "qualifier" => qualifier})) end
   def post3(conn,base,resource,qualifier) do
       :io.format 'POST/3 #{base}/#{resource}/#{qualifier}', []
       send_resp(conn, 200, encode(%{"base" => base, "resource" => resource, "qualifier" => qualifier})) end
   def post4(conn,base,compartment,id,qualifier) do
       :io.format 'POST/4 #{base}/#{compartment}/#{qualifier}', []
       send_resp(conn, 200, encode(%{"base" => base, "compartment" => compartment, "id" => id, "qualifier" => qualifier})) end
   def post5(conn,base,compartment,id,resource,qualifier) do
       :io.format 'POST/5 #{base}/#{compartment}/#{id}#{qualifier}', []
       send_resp(conn, 200, encode(%{"base" => base, "compartment" => compartment, "resource" => resource,  "id" => id, "qualifier" => qualifier})) end
end
