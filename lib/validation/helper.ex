defmodule Xema.Castable.Helper do
  @moduledoc false

  def to_existing_atom(atom) when is_atom(atom), do: atom
  def to_existing_atom(string) when is_binary(string) do String.to_existing_atom(string) rescue  _ -> nil  end

  defp to_integer(value) when is_integer(value), do: {:ok, value}

  defp to_integer(value) when is_binary(value) do
    case Integer.parse(value) do
      {integer, ""} -> {:ok, integer}
      _error -> :error
    end
  end

  defp to_integer(_value), do: :error

  def item(item, keys: true), do: item
  def item({_key, value}, keys: false), do: value

  def to_sorted_list(map, opts \\ [keys: true]) do
    result =
      Enum.reduce_while(map, [], fn {key, _value} = item, acc ->
        case to_integer(key) do
          {:ok, integer} -> {:cont, [{integer, item(item, opts)} | acc]}
          :error -> {:halt, nil}
        end
      end)

    case result do
      nil ->
        :error

      list ->
        list =
          list
          |> Enum.sort_by(fn {index, _value} -> index end)
          |> Enum.map(fn {_index, value} -> value end)

        {:ok, list}
    end
  end

  defmacro __using__(_) do
    quote do
      import Xema.Castable.Helper
      import Xema.Utils, only: [to_existing_atom: 1]

      alias Xema.Schema

      def cast(value, %Schema{type: :any}), do: {:ok, value}

      def cast(value, %Schema{type: type}) when is_boolean(type), do: {:ok, value}

      def cast(value, %Schema{type: type, module: module} = schema),
        do: cast(value, type, module, schema)

      def cast(atom, types, module, schema) when is_list(types),
        do:
          types
          |> Stream.map(fn type -> cast(atom, type, module, schema) end)
          |> Enum.find(%{to: types, value: atom}, fn
            {:ok, _} -> true
            {:error, _} -> false
          end)
    end
  end

  def to_integer(str, type) when type in [:integer, :number] do
    case Integer.parse(str) do
      {int, ""} -> {:ok, int}
      _ -> {:error, %{to: type, value: str}}
    end
  end

  def to_float(str, type) when type in [:float, :number] do
    case Float.parse(str) do
      {int, ""} -> {:ok, int}
      _ -> {:error, %{to: type, value: str}}
    end
  end

  def module(module) do
    if module == nil, do: :struct, else: module
  end

  def check_keyword(list, to) do
    case Keyword.keyword?(list) do
      true -> :ok
      false -> {:error, %{to: to, value: list}}
    end
  end

  def cast_key(value, :atoms) when is_binary(value) do
    case to_existing_atom(value) do
      nil -> :error
      cast -> {:ok, cast}
    end
  end

  def cast_key(value, :strings) when is_atom(value),
    do: {:ok, Atom.to_string(value)}

  def cast_key(value, _),
    do: {:ok, value}

  def to_struct(module, values) do
    {:ok, struct!(module, values)}
  rescue
    error in KeyError ->
      {:error, %{to: module, key: error.key, value: values}}

    error in ArgumentError ->
      {:error, %{to: module, value: values, error: error}}
  end

  def fields(map) do
    Enum.reduce_while(map, {:ok, %{}}, fn {key, value}, {:ok, acc} ->
      case cast_key(key, :atoms) do
        {:ok, key} ->
          {:cont, {:ok, Map.put(acc, key, value)}}

        :error ->
          {:halt, {:error, %{to: :struct, key: key}}}
      end
    end)
  end
end
