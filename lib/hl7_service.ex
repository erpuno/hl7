defmodule HL7.Service do
   import Plug.Conn

# Implemented

   def meta(conn),                                          do: HL7.Meta.meta(conn)
   def get4(conn,base,type,id,spec),                        do: HL7.Get.get(conn,base,type,id,spec)
   def post4(conn,base,type,id,"$validate" = spec),         do: HL7.Validate.validate(conn,base,type,id,spec)
   def post4(conn,base,compartment,id,qualifier),           do: HL7.Compartment.compartment(conn,base,compartment,id,qualifier)
   def put4(conn,base,type,id,spec),                        do: HL7.Put.put(conn,base,type,id,spec)
   def delete4(conn,base,type,id,spec),                     do: HL7.Delete.delete(conn,base,type,id,spec)
   def post2(conn,base,qualifier),                          do: HL7.Search.search(conn,base,qualifier)
   def post3(conn,base,resource,qualifier),                 do: HL7.Search.post3(conn,base,qualifier)
   def post5(conn,_base,compartment,id,resource,qualifier), do: HL7.Compartment.post5(conn,_base,compartment,id,resource,qualifier)

# Not Implemented Yet

   def postRoot(conn),   do: send_resp(conn, 200, encode([%{}]))
   def postDiff(conn),   do: send_resp(conn, 200, encode([%{}]))
   def postExport(conn), do: send_resp(conn, 200, encode([%{}]))
   def postMeta(conn),   do: send_resp(conn, 200, encode([%{}]))
   def reindex(conn),    do: send_resp(conn, 200, encode([%{}]))
   def root(conn),       do: send_resp(conn, 200, encode([%{}]))
   def history(conn),    do: send_resp(conn, 200, encode([%{}]))
   def diff(conn),       do: send_resp(conn, 200, encode([%{}]))
   def metadata(conn),   do: send_resp(conn, 200, encode([%{"resourceType" => "CapabilityStatement"}]))
   def export(conn),     do: send_resp(conn, 200, encode([%{"resourceType" => "CapabilityStatement"}]))

# Reference Implementation: http://hapi.fhir.org/

   def encode(x) do
       case  Jason.encode(x) do
             {:ok, bin} -> bin <> "\n"
             {:error, %Protocol.UndefinedError{protocol: _, value: value, description: desc}} -> desc <> "\n"
             {:error, %Protocol.UndefinedError{description: _, protocol: _, value: {:error, %Xema.ValidationError{message: _, reason: err}}}} -> err <> "\n"
             {:error, %Xema.ValidationError{message: _, reason: err}} -> err <> "\n"
       end |> Jason.Formatter.pretty_print
   end

end
