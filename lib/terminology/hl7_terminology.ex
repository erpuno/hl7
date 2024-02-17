defmodule HL7.Terminology.Terminology do
  def show(name) do
      file = "terminology/TerminologyCapabilities/TerminologyCapabilities-#{name}.json"
      {_,objBin} = :file.read_file file
      schema = HL7.Loader.loadSchema("TerminologyCapabilities")
      obj = Jason.decode!(objBin)
      id = Map.get(obj, "identifier")
      publisher = Map.get(obj, "implementation")
      codeSystem = Map.get(obj, "codeSystem")
      res = :lists.flatten :lists.map(fn x ->
        uri = Map.get(x, "uri")
        version = Map.get(x, "version", [])
        content = Map.get(x, "content", [])
        {uri,version,content}
       end, codeSystem)
      verify = Xema.validate(schema, obj)
      {name,verify,id,publisher,res}
  end
end
