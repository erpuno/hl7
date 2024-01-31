defmodule HL7.Loader do
  @moduledoc false

  @behaviour Xema.Loader

  def loadSchema(id) do
      refs = :application.get_env(:hl7, "#{id}", [])
      case refs do
           [] -> name = "schema/#{id}.schema.json"
                 {_,bin} = :file.read_file name
#                :io.format 'loadSchema: ~p~n', [name]
                 xema = Jason.decode!(bin) |> Xema.from_json_schema()
                 :application.set_env(:hl7, "#{id}", xema)
                 xema
           schema -> schema
      end
  end

  @spec fetch(binary) :: {:ok, map} | {:error, any}
  def fetch(uri) do
      base = :filename.basename(uri.path, '.schema.json')
      refs = :application.get_env(:hl7, "#{base}", [])
      case refs do
           [] -> xema = HL7.Loader.loadSchema("#{base}")
                 %{schema: mem} = xema
                 {:ok, mem}
           xema ->
                 %{schema: mem} = xema
                 {:ok, mem}
      end
  end
end
