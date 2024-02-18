defmodule HL7.Validation do
  import HL7.Terminology.Hierarchy

  def suite() do
      {_,_,_,_,x} = HL7.showCodeSystem("ResourceType")
      :lists.flatten :lists.map(fn {_,_,atom,bin} ->
           case HL7.Loader.testSchema bin do
                 true -> atom
                false -> [] # [{atom] # uncomment to see unsupported (yet) resourcees
           end
      end, x)
  end

  def clear_cache() do
      :lists.flatten(
      :lists.map(fn {y,_} when is_binary(y) ->
#       :application.set_env(:hl7, y, [])
        {y}
        ; _ -> [] end,
      :application.get_all_env(:hl7)))
  end

  def split(array) do :lists.split(:erlang.div(:erlang.length(array),2),array) end

  def load() do
      :lists.map fn x ->
          {time,_} = :timer.tc(fn -> HL7.Loader.loadSchema "#{x}" end)
          :io.format 'load: ~p (μs), file: ~ts.~n', [time,"#{x}"]
          {time,x}
      end, suite()
  end

  def test() do
      # load()
      :lists.sort :lists.map fn x ->
          {time,{name,code}} = :timer.tc(fn -> validateSample "#{x}" end)
          :io.format 'validation: ~p (μs), schema: ~ts.~n', [time,"#{name}"]
          {status(code),:erlang.binary_to_atom(name),time}
      end, suite()
#     {x,y} = split(s) ; {a,b} = split(x) ; {c,d} = split(y) ; [a,b,c,d] # R5/160
  end

  def validateSample(name) do
      file = "samples/#{name}/#{name}.json"
      {_,objBin} = :file.read_file file
#     :io.format 'validateSample: ~p~n', [name]
      schema = HL7.Loader.loadSchema("#{name}")
      obj = Jason.decode!(objBin)
      verify = Xema.validate(schema, obj)
      {name,verify}
  end

end
