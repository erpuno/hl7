defmodule HL7.Validation do

  def test() do
      :application.set_env(:hl7, :definitions, [])
      :lists.map fn x -> testItem(:lists.concat([x])) end,
      [ :Identifier, :Quantity, :Reference, :Location ]
  end

  def testItem(name) do
      {_,schemaBin} = :file.read_file "schema/#{name}.schema.json"
      schemaJson = Jason.decode!(schemaBin)
      {_,objBin} = :file.read_file "samples/json/#{name}/#{name}.json"
      schema = Xema.from_json_schema(schemaJson)
      obj = Jason.decode!(objBin, keys: :atoms)
      verify = Xema.valid?(schema, obj)
      {name,verify}
  end

end
