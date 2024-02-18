defmodule HL7 do
  @moduledoc """
  """
  require Record

  @schema [ :"Person", :"Patient", :"Location", :"Organization", :"Composition",
            :"DeviceDefinition", :"DeviceDispense", :"DeviceRequest" ]

  Enum.each(@schema,
    fn t ->
      Enum.each(
        Record.extract_all(
          from_lib: "hl7/include/" <> :erlang.list_to_binary(:erlang.atom_to_list(t)) <> ".hrl"
        ),
        fn {name, definition} ->
          prev = :application.get_env(:kernel, :hl7_tables, [])
          prev2 = :application.get_env(:hl7, :hl7_fields, [])
          case :lists.member(name, prev) do
            true ->
              :skip

            false ->
              Record.defrecord(name, definition)
              :application.set_env(:kernel, :hl7_tables, [name | prev])
              :application.set_env(:hl7, :hl7_fields, [{name,definition} | prev2])
          end
        end
      )
    end
  )

  def schema(), do: @schema

  # Maintenance Shell

  def showCodeSystem(name),  do: HL7.Terminology.CodeSystem.show(name)
  def showValueSet(name),    do: HL7.Terminology.ValueSet.show(name)
  def showTerminology(name), do: HL7.Terminology.show(name)

end
