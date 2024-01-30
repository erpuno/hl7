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
   def history(conn), do: send_resp(conn, 200, encode([%{}]))
   def diff(conn), do: send_resp(conn, 200, encode([%{}]))
   def metadata(conn), do: send_resp(conn, 200, encode([%{"resourceType" => "CapabilityStatement"}]))
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

   def get4(conn,_base,type,id,spec) do
       :io.format 'GET/4:#{type}/#{id}/#{spec}', []
       send_resp(conn, 200, encode([%{"type" => type, "id" => id, "spec" => spec}])) end

   def post4(conn,_,type,id,"$validate" = spec) do
       {:ok, body, conn} = Plug.Conn.read_body(conn, [])
       schema = HL7.Loader.loadSchema("#{type}") 
       obj = Jason.decode!(body)
       res = case Xema.validate(schema, obj) do
             :ok -> {%{message: "Object conforms to #{type} of R5 schema.", code: "success"},"success"}
             {:error, %Xema.ValidationError{message: msg, reason: err}} -> {%{message: msg, reason: err},"error"}
       end
       {message,verify} = res
       :io.format 'POST/4:#{type}#{id}/#{spec}: ~p (~pKiB)', [verify, :erlang.round(:erlang.size(body) / 1024)]
       send_resp(conn, 200, encode(%{"type" => type, "id" => Map.get(obj, "id", Map.get(obj, "$id", "")), "spec" => spec, "verify" => message})) end

   def post4(conn,_base,compartment,id,qualifier) do
       :io.format 'POST/4:#{compartment}/#{qualifier}', []
       send_resp(conn, 200, encode(%{"compartment" => compartment, "id" => id, "qualifier" => qualifier})) end

   def put4(conn,_base,type,id,spec) do
       :io.format 'PUT/4:#{type}#{id}/#{spec}', []
       send_resp(conn, 200, encode(%{"type" => type, "id" => id, "spec" => spec})) end

   def delete4(conn,_base,type,id,spec) do
       :io.format 'DELETE/3:#{type}#{id}/#{spec}', []
       send_resp(conn, 200, encode(%{"type" => type, "id" => id, "spec" => spec})) end

   def get2(conn,_base,qualifier) do
       :io.format 'GET/2:#{qualifier}', []
       send_resp(conn, 200, encode([%{"qualifier" => qualifier}])) end

   def post2(conn,_base,qualifier) do
       :io.format 'POST/2:#{qualifier}', []
       send_resp(conn, 200, encode(%{"qualifier" => qualifier})) end

   def post3(conn,_base,resource,qualifier) do
       :io.format 'POST/3:#{resource}/#{qualifier}', []
       send_resp(conn, 200, encode(%{"resource" => resource, "qualifier" => qualifier})) end

   def post5(conn,_base,compartment,id,resource,qualifier) do
       :io.format 'POST/5:#{compartment}/#{id}#{qualifier}', []
       send_resp(conn, 200, encode(%{"compartment" => compartment, "resource" => resource,  "id" => id, "qualifier" => qualifier})) end
end
