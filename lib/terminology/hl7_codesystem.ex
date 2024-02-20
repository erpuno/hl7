defmodule HL7.Terminology.CodeSystem do
  import HL7.Terminology.Hierarchy
  def show(name) do
      lvl = 1
      file = HL7.priv <> "terminology/CodeSystem/CodeSystem-#{name}.json"
      {_,objBin} = :file.read_file file
      schema = HL7.Loader.loadSchema("CodeSystem")
      obj = Jason.decode!(objBin)
      id = Map.get(obj, "id")
      url = Map.get(obj, "url")
      list = Map.get(obj, "concept")
      res = :lists.flatten :lists.map(fn x ->
        code = Map.get(x, "code")
        display = Map.get(x, "display", [])
        concept = Map.get(x, "concept", [])
        id = Map.get(x, "id")
        [case id do nil when name == "CodeSystem" -> [] ; _ -> {lvl,id,:erlang.binary_to_atom(code),display} end]
        ++ foldConcept(name, concept, lvl + 1)
       end, list)
      verify = Xema.validate(schema, obj)
      {name,verify,id,url,res}
  end
end
