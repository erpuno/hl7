defmodule HL7.Terminology.Hierarchy do
  def status(:ok) do "OK" end
  def status({:error, %Xema.ValidationError{reason: %{all_of: x}}}) do x end
  def foldConcept(_name, [], _lvl), do: []
  def foldConcept(name, list, lvl) do
      res = :lists.flatten( :lists.map(fn x ->
        id = Map.get(x, "id")
        case id do
             nil when name == "CodeSystem" -> []
             _ ->
               code = :erlang.binary_to_atom Map.get(x, "code")
               display = Map.get(x, "display")
               concept = Map.get(x, "concept")
               [{lvl,id,code,display}] ++
               case concept do
                 nil -> []
                   _ -> foldConcept(code, concept, lvl+1)
               end
        end
      end, list))
      res
  end
end