defmodule My.Loader do
  @moduledoc false

  @behaviour Xema.Loader

  @spec fetch(binary) :: {:ok, map} | {:error, any}
  def fetch(uri) do
      name = :filename.basename(uri.path, '.json') <> ".json"
      {_,bin} = :file.read_file name
      IO.inspect bin
      schema = Jason.decode!(bin)
      :io.format 'Uri: ~p~n', [uri.path]
      xema = schema |> Xema.from_json_schema |> Xema.JsonSchema.to_xema
      {:ok, xema}
  end
end
