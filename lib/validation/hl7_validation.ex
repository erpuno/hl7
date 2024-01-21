defmodule HL7.Validation do
  def location() do
      {_,bin} = :file.read_file "samples/json/Location/Location.json"
      {_,map} = Jason.decode(bin, keys: :atoms)
      map
  end

  def schemaLocation() do
      locationSchema = Xema.new {:map,
        keys: :atoms,
        definitions: %{
          Organization: :map,
          Reference: :map
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
          address: :any,
          description: :any,
          status: :string,
          managingOrganization: {:ref, "#/definitions/Reference"},
          text: {:map, properties: %{div: :string, status: :string}},
          position: {:map, properties: %{altitude: :number, latitude: :number, longtitude: :number}},
          resourceType: {:string, value: "Location"}
        },
        additional_properties: false
      }
      
      Xema.validate(locationSchema, location())
  end

end