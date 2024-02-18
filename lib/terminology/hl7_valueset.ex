defmodule HL7.Terminology.ValueSet do
  def show(name) do
      lvl = 1
      file = "terminology/ValueSet/ValueSet-#{name}.json"
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
          code = Map.get(x, "code")
          display = Map.get(x, "display", [])
          {lvl,system,:erlang.binary_to_atom(code),display}
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
