defmodule HL7.Schema do
  require Record

   def metainfo(), do: KVS.schema( name: :hl7, tables: hl7())

   def table(name) do
       hl7_fields = :application.get_env(:exosculat, :hl7_fields, [])
       {a,b} = :lists.unzip(:proplists.get_value(name, hl7_fields, []))
       KVS.table(name: name, fields: a, instance: b)
   end

   def hl7(), do: :lists.map(fn x -> table(x) end, HL7.schema())

end
