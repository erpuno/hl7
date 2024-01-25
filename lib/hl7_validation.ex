defmodule HL7.Validation do

  def test() do
      :application.set_env(:hl7, :definitions, [])
      :lists.map fn x -> testItem(:lists.concat([x])) end,
      [ :Identifier, :Quantity, :Reference, :Location,
        :Extension, :Patient, :Specimen, :Observation,
        :List, :Encounter, :Contract, :Device, :Organization
      ]
  end

  def testItem(name) do
      schemaFile = "schema/#{name}.schema.json"
      {_,schemaBin} = :file.read_file schemaFile
      schemaJson = Jason.decode!(schemaBin)
      file = "samples/json/#{name}/#{name}.json"
      {_,objBin} = :file.read_file file
      schema = Xema.from_json_schema(schemaJson)
      obj = Jason.decode!(objBin)
      verify = Xema.validate(schema, obj)
      {name,verify}
  end

end
