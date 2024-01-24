defmodule HL7.Loader do
  @moduledoc false

  @behaviour Xema.Loader

  def loadSchema(id) do
      name = "schema/" <> id <> ".schema.json"
      {_,bin} = :file.read_file name
      schema = Jason.decode!(bin)
      %{schema: xema} = schema |> Xema.from_json_schema()
      xema
  end

  @spec fetch(binary) :: {:ok, map} | {:error, any}
  def fetch(uri) do
      base = :filename.basename(uri.path, '.schema.json')
      name = "schema/" <> base <> ".schema.json"
      refs = :application.get_env(:hl7, :definitions, [])
      case :lists.keyfind(base, 1, refs) do
           false -> :io.format 'uri: ~p~n', [uri.path]
                    {_,bin} = :file.read_file name
                    schema = Jason.decode!(bin)
                    %{schema: xema} = schema |> Xema.from_json_schema()
                    defs = :application.get_env(:hl7, :definitions, [])
                    :application.set_env(:hl7, :definitions, [{base,xema}|defs])
                    {:ok, xema}
          {_,schema} -> {:ok, schema}
      end
  end
end
