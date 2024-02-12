defmodule Xema.JsonSchema do
  @moduledoc """
  Converts a JSON Schema to Xema source.
  """

  alias Xema.{
    JsonSchema.Validator,
    Schema,
    SchemaError
  }

  @type json_schema :: true | false | map
  @type opts :: [draft: String.t()]

  @drafts ~w(draft4 draft6 draft7)

  @schema ~w(
    additional_items
    additional_properties
    property_names
    not
    if
    then
    else
    contains
    items
  )a

  @schemas ~w(
    all_of
    any_of
    one_of
    items
  )a

  @schema_map ~w(
    definitions
    pattern_properties
    properties
  )a

  defmacro keywords() do
      Schema.keywords()
      |> Enum.map(&to_string/1)
      |> ConvCase.to_camel_case()
      |> List.delete("ref")
      |> List.delete("schema")
      |> Enum.concat(["$ref", "$id", "$schema"])
  end

  @doc """
  This function converts a JSON Schema in Xema schema source. The argument
  `json_schema` is expected as a decoded JSON Schema.

  All keys that are not standard JSON Schema keywords have to be known atoms. If
  the schema has additional keys that are unknown atoms the option
  `atom: :force` is needed. In this case the atoms will be created. This is not
  needed for keys expected by JSON Schema (e.g. in properties)

  Options:
  * `:draft` specifies the draft to check the given JSON Schema. Possible values
    are `"draft4"`, `"draft6"`, and `"draft7"`, default is `"draft7"`. If
    `:draft` not set and the schema contains `$schema` then the value for
    `$schema` is used for this option.
  * `:atom` creates atoms for unknown atoms when set to `:force`. This is just
    needed for additional JSON Schema keywords.

  ## Examples

      iex> Xema.JsonSchema.to_xema(%{"type" => "integer", "minimum" => 5})
      {:integer, [minimum: 5]}

      iex> schema = %{
      ...>   "type" => "object",
      ...>   "properties" => %{"foo" => %{"type" => "integer"}}
      ...> }
      iex> Xema.JsonSchema.to_xema(schema)
      {:map, [keys: :strings, properties: %{"foo" => :integer}]}

      iex> Xema.JsonSchema.to_xema(%{"type" => "integer", "foo" => "bar"}, atom: :force)
      {:integer, [foo: "bar"]}
  """
  @spec to_xema(json_schema, opts) :: atom | tuple
  def to_xema(json_schema, opts \\ []) do
    draft = draft(json_schema, opts)

    case Validator.validate(draft, json_schema) do
      :ok ->
        do_to_xema(json_schema, opts)

      {:error, :unknown} ->
        raise "unknown draft #{inspect(draft)}, has to be one of #{inspect(@drafts)}"

      {:error, reason} ->
        raise SchemaError, reason
    end
  end

  defp do_to_xema(json, opts) when is_map(json) do
    {type, json} = type(json)

    cond do
      Enum.empty?(json) ->
        type

      type == :map ->
        {:map, json |> Map.put("keys", :strings) |> schema(opts)}

      true ->
        {type, schema(json, opts)}
    end
  end

  defp do_to_xema(json, _) when is_boolean(json), do: json

  defp type(map) do
    {type, map} = Map.pop(map, "type", :any)
    {type_to_atom(type), map}
  end

  defp draft(json_schema, opts) when is_map(json_schema) do
    draft = Map.get(json_schema, "$schema", "draft7")
    Keyword.get(opts, :draft, draft)
  end

  defp draft(_json_schema, opts), do: Keyword.get(opts, :draft, "draft7")

  defp type_to_atom(list) when is_list(list), do: Enum.map(list, &type_to_atom/1)

  defp type_to_atom("object"), do: :map

  defp type_to_atom("array"), do: :list

  defp type_to_atom("null"), do: nil

  defp type_to_atom(type) when is_binary(type), do: to_existing_atom(type)

  defp type_to_atom(type), do: type

  defp schema(json, opts) do
    json
    |> Enum.map(&rule(&1, opts))
    |> Keyword.new()
  end

  # handles all rules with a regular keyword

  def keywordsDefault(key,value,opts) do
    key
    |> String.trim_leading("$")
    |> ConvCase.to_snake_case()
    |> to_existing_atom(opts)
    |> rule(value, opts)
  end

#["propertyNames", "maxProperties", "contentMediaType", "examples", "default",
# "if", "description", "maximum", "id", "items", "then", "additionalItems",
# "definitions", "properties", "patternProperties", "contains", "oneOf", "else",
# "minItems", "caster", "contentEncoding", "pattern", "title",
# "exclusiveMinimum", "enum", "maxLength", "type", "additionalProperties",
# "required", "validator", "keys", "maxItems", "module", "dependencies", "not",
# "anyOf", "multipleOf", "format", "minLength", "const", "allOf", "minimum",
# "exclusiveMaximum", "uniqueItems", "comment", "minProperties", "$ref", "$id",
# "$schema"]

  defp rule({"propertyNames" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"maxProperties" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"contentMediaType" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"examples" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"default" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"if" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"description" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"maximum" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"id" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"items" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"then" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"additionalItems" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"definitions" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"properties" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"comment" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"module" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"caster" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"pattern" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"title" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"oneOf" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"allOf" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"else" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"validator" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"enum" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"anyOf" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"multipleOf" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"format" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"not" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"dependencies" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"contentEndoding" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"minLength" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"maxLength" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"minItems" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"maxItems" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"exclusiveMaximum" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"const" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"minimum" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"uniqueItems" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"minProperties" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"additionalProperties" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"$ref" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"$id" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"$schema" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"required" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"keys" = key, value}, opts), do: keywordsDefault(key,value,opts)
  defp rule({"type" = key, value}, opts), do: keywordsDefault(key,value,opts)

#  defp rule({key, value}, opts) when key in keywords() do
#    key
#    |> String.trim_leading("$")
#    |> ConvCase.to_snake_case()
#    |> to_existing_atom(opts)
#    |> rule(value, opts)
#  end

  # handles all rules without a regular keyword
  defp rule({key, value}, opts) when is_binary(key) and is_map(value) do
    value =
      case schema?(value) do
        true -> do_to_xema(value, opts)
        false -> schema(value, opts)
      end

    {to_existing_atom(key, opts), value}
  end

  defp rule({key, value}, opts), do: {to_existing_atom(key, opts), value}

  defp rule(:format, value, _) do
    format = value |> ConvCase.to_snake_case()
                   |> to_existing_atom(maybe: true)

    case is_atom(format) do
      true -> {:format, format}
      false -> {:format, :unsupported}
    end
  end

  defp rule(:dependencies, value, opts) do
    value =
      Enum.into(value, %{}, fn
        {key, value} when is_map(value) -> {key, do_to_xema(value, opts)}
        {key, value} -> {key, value}
      end)

    {:dependencies, value}
  end

  defp rule(key, value, opts) when key in @schema_map do
    {key, Enum.into(value, %{}, fn {key, value} -> {key, do_to_xema(value, opts)} end)}
  end

  defp rule(key, value, opts) when key in @schemas and is_list(value) do
    {key, Enum.map(value, &do_to_xema(&1, opts))}
  end

  defp rule(key, value, opts) when key in @schema do
    {key, do_to_xema(value, opts)}
  end

  defp rule(key, value, _), do: {key, value}

  defp schema?(value) do
    value |> Map.keys() |> Enum.any?(fn key -> Enum.member?(keywords(), key) end)
  end

  defp to_existing_atom(str, opts \\ []) do
    case Keyword.get(opts, :atom, :force) do
      :existing -> String.to_existing_atom(str)
      :force -> String.to_atom(str)
    end
  rescue
    _ ->
      case Keyword.get(opts, :maybe, false) do
        true ->
          str

        false ->
          reraise SchemaError,
                  "All additional schema keys must be existing atoms. Missing atom for #{str}",
                  __STACKTRACE__
      end
  end
end
