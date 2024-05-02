defmodule HL7.Terminology.ValueSet do
  import HL7.Terminology.Hierarchy
  def show(name) do
      lvl = 1
      file = HL7.priv <> "terminology/ValueSet/ValueSet-#{name}.json"
      {_,objBin} = :file.read_file file
      schema = HL7.Loader.loadSchema("ValueSet")
      obj = Jason.decode!(objBin)
      id = Map.get(obj, "id")
      url = Map.get(obj, "url")
      compose = Map.get(obj, "compose")
      include = Map.get(compose, "include",[])
      res = :lists.flatten :lists.map(fn i ->
        system = Map.get(i, "system")
        list = Map.get(i, "concept", [])
        res = :lists.map(fn x ->
          code = Map.get(x, "code", [])
          display = Map.get(x, "display", [])
          concept = Map.get(x, "concept", [])
          id = Map.get(x, "id", [])
          [case id do nil when name == "ValueSet" -> [] ; _ ->
          {lvl,system,:erlang.binary_to_atom(code),display} end]
          ++ 
          foldConcept(name, concept, lvl + 1)
        end, list)
        case res do
             [] -> {lvl,system,:system,:only}
             x -> x
        end
      end, include)
      verify = Xema.validate(schema, obj)
      {name,verify,id,url,res}
  end
end
