defmodule HL7.Validation do

  def suite() do
      [
        :Identifier, :Quantity, :Reference, :Location,
        :Extension, :Patient, :Specimen, :Observation,
        :List, :Encounter, :Contract, :Device, :Organization,
        :DeviceDefinition, :DeviceAssociation, :DetectedIssue,
        :BodyStructure, :Account, :AdverseEvent, :CarePlan, :CareTeam
      ]
  end

  def cache() do
      :lists.flatten(
      :lists.map(fn {y,_} when is_binary(y) -> {y} ; _ -> [] end,
      :application.get_all_env(:hl7)))
  end

  def test() do
      x = :lists.map fn x ->
         {time,_} = :timer.tc(fn -> HL7.Loader.loadSchema "#{x}" end)
          :io.format 'load: ~p (μs), file: ~ts.~n', [time,"#{x}"]
         {time,x}
      end, suite()
      y = :lists.map fn x ->
         {time,{name,_}} = :timer.tc(fn -> testItem "#{x}" end)
          :io.format 'validation: ~p (μs), schema: ~ts.~n', [time,"#{name}"]
         {time,name}
      end, suite()
      v = cache()
      {v,length(v),x,y}
  end

  def testItem(name) do
      file = "samples/json/#{name}/#{name}.json"
      {_,objBin} = :file.read_file file
      schema = HL7.Loader.loadSchema("#{name}")
      obj = Jason.decode!(objBin)
      verify = Xema.validate(schema, obj)
      {name,verify}
  end

end
