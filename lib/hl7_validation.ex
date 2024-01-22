defmodule HL7.Validation do
 
  def test(name \\ "Quantity") do
      {_,schemaBin} = :file.read_file "samples/schema/#{name}.schema.json"
      schemaJson = Jason.decode!(schemaBin)
      {_,objBin} = :file.read_file "samples/json/#{name}/#{name}.json"
      schema = Xema.from_json_schema(schemaJson)
      obj = Jason.decode!(objBin, keys: :atoms)
      verify = Xema.valid?(schema, obj)
      {schema,obj,verify}
  end

  def location(name \\ "Location") do
      {_,bin} = :file.read_file "samples/json/#{name}/#{name}.json"
      {_,map} = Jason.decode(bin, keys: :atoms)
      map
  end

  def schemaLocation() do
      locationSchema = Xema.new {:map,
        keys: :atoms,
        definitions: %{
          Address: :any,
          Reference: :any,
        },
        properties: %{
          id: :string,
          name: :string,
          mode: :string,
          form: :any,
          identifier: :any,
          endpoint: :any,
          characteristic: :any,
          contact: :any,
          alias: :any,
          address: {:ref, "#/definitions/Address"},
          description: :any,
          status: :string,
          managingOrganization: {:ref, "#/definitions/Reference"},
          text: {:map, properties: %{div: :string, status: :string}},
          position: {:map, properties: %{altitude: :number, latitude: :number, longtitude: :number}},
          resourceType: {:string, value: "Location"}
        },
        additional_properties: false
      }
      obj = location()
      {locationSchema,obj,Xema.validate(locationSchema, obj)}
  end

end