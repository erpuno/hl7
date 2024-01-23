defmodule HL7.Loader do
  @moduledoc false

  @behaviour Xema.Loader

  @spec fetch(binary) :: {:ok, map} | {:error, any}
  def fetch(uri) do
      base = :filename.basename(uri.path, '.schema.json')
      name = "schema/" <> base <> ".schema.json"
      refs = :application.get_env(:hl7, :definitions, [])
      case :lists.keyfind(base, 1, refs) do
           false -> :io.format 'Uri: ~p~n', [name]
                    {_,bin} = :file.read_file name
                    schema = Jason.decode!(bin)
                    %{schema: xema} = schema |> Xema.from_json_schema()
                    defs = :application.get_env(:hl7, :definitions, [])
                    :application.set_env(:hl7, :definitions, [{base,xema}|defs])
                    # :io.format 'ENV: ~p~n', [[{base,xema}|defs]]
                    {:ok, xema}
          {_,schema} -> {:ok, schema}
      end
  end
end
