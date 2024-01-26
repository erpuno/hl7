defmodule HL7.Validation do

  def suite() do
      [ :Identifier, :Quantity, :Reference, :Location,
        :Extension, :Patient, :Specimen, :Observation,
        :List, :Encounter, :Contract, :Device, :Organization,
        :DeviceDefinition, :DeviceAssociation, :DetectedIssue,
        :BodyStructure, :Procedure, :Coverage,
        :Practitioner, :PractitionerRole,
        :Medication, :MedicationDispense, :MedicationRequest
      ]
  end

  def loadSchema() do
      :lists.map(fn x -> loadSchema(:lists.concat([x])) end, suite())
  end

  def test() do
      :application.set_env(:hl7, :definitions, [])
#      loadSchema()
      :lists.map fn x ->
         {time,{res,_}} = :timer.tc(fn -> testItem(:lists.concat([x])) end)
         :io.format 'Timer: ~p, Item: ~p~n', [time,res]
         {time,:erlang.iolist_to_binary res}
       end, suite()
  end

  def loadSchema(name) do
      schemaFile = "schema/#{name}.schema.json"
      {_,schemaBin} = :file.read_file schemaFile
      schemaJson = Jason.decode!(schemaBin)
      %{schema: xema} = schemaJson |> Xema.from_json_schema()
      defs = :application.get_env(:hl7, :definitions, [])
      :application.set_env(:hl7, :definitions, [{:erlang.iolist_to_binary(name),xema}|defs])
      xema
  end

  def testItem(name) do
      schemaFile = "schema/#{name}.schema.json"
      {_,schemaBin} = :file.read_file schemaFile
#      :io.format 'file: ~p~n', [schemaFile]
      schemaJson = Jason.decode!(schemaBin)
      file = "samples/json/#{name}/#{name}.json"
      {_,objBin} = :file.read_file file
      schema = Xema.from_json_schema(schemaJson)
      obj = Jason.decode!(objBin)
      verify = Xema.validate(schema, obj)
      {name,verify}
  end

end
