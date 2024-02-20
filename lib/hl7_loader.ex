defmodule HL7.Loader do
  @moduledoc false
  @behaviour Xema.Loader
  def testSchema(atom,id) do
      case :filelib.is_file HL7.priv <> "schema/#{id}.schema.json" do
            true -> atom
           false -> [{atom}] # [{atom] # uncomment to see unsupported (yet) resourcees
      end
  end
  def loadSchema(id) do
      refs = :application.get_env(:hl7, "#{id}", [])
      case refs do
           [] -> name = HL7.priv <> "schema/#{id}.schema.json"
                 {_,bin} = :file.read_file name
#                :io.format 'loadSchema: ~p~n', [name]
                 xema = Jason.decode!(bin) |> Xema.from_json_schema()
                 :application.set_env(:hl7, "#{id}", xema)
                 xema
       schema -> schema end end
  @spec fetch(binary) :: {:ok, map} | {:error, any}
  def fetch(uri) do
      base = :filename.basename(uri.path, '.schema.json')
      refs = :application.get_env(:hl7, "#{base}", [])
#      :io.format 'fetchSchema: ~p~n', [uri]
      case refs do
             [] -> xema = HL7.Loader.loadSchema("#{base}")
                   %{schema: mem} = xema ; {:ok, mem}
           xema -> %{schema: mem} = xema ; {:ok, mem} end end
end
