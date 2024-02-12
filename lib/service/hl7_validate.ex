defmodule HL7.Validate do
  import Plug.Conn
  def validate(conn,_,type,id,"$validate" = spec) do
       fun = fn
             (%Xema.ValidationError{message: _, reason: %{required: req}}, _path, acc) ->
               fields = :string.join :lists.map(fn x -> :erlang.binary_to_list(x) end, req), ','
               [%{"details" => "Fields [#{fields}] are required.",
                 "severity" => "error",
                 "code" => "structure"}
               |acc]
             (%Xema.ValidationError{message: _, reason: %{all_of: [%{properties: errors}]}}, _path, acc) ->
             [:lists.map(fn err ->
               %{"details" => Jason.encode!(Map.get(errors, err)),
                 "severity" => "error",
                 "code" => "structure"}
             end, Map.keys(errors))|acc]
             (%Xema.ValidationError{message: _, reason: %{properties: errors}}, _path, acc) ->
             [:lists.map(fn err ->
               %{"details" => Jason.encode!(Map.get(errors, err)),
                 "severity" => "error",
                 "expression" => type <> "." <> err,
                 "code" => "value"}
             end, Map.keys(errors))|acc]
       end
       {:ok, body, conn} = Plug.Conn.read_body(conn, [])
       schema = HL7.Loader.loadSchema("#{type}")
       obj = Jason.decode!(body)
       res = case Xema.validate(schema, obj) do
             {:error, %Xema.ValidationError{message: _, reason: _}} = errors ->
             :io.format 'Validation Errors: ~p~n', [errors]
              Xema.ValidationError.travers_errors(errors, [], fun)
             :ok ->
                case Map.get(obj, "text") do
                nil ->
                [%{"details" => "dom-6: A resource should have narrative for robust management",
                  "severity" => "warning",
                  "expression" => type,
                  "code" => "invariant"
                  }]
                _ ->
                 []
               end ++
               [%{"details" => "Validation is successful!",
                  "severity" => "information",
                  "code" => "informational"}]
       end
       :io.format 'POST/4:#{type}#{id}/#{spec}: ~p (~pKiB)', [res,:erlang.round(:erlang.size(body) / 1024)]
       send_resp(conn, 200, HL7.Service.encode(%{"resourceType" => "OperationOutcome", "issues" => res}))
  end
end