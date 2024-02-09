defmodule HL7.Application do
  use Application
  def port, do: Application.get_env(:hl7, :port, 9234)
  def start(_, _) do
      children = [ { Plug.Cowboy, scheme: :http, plug: HL7.Endpoint, options: [port: port()] } ]
      opts = [strategy: :one_for_one, name: App.Supervisor]
      :io.format "ISO/HL7 27931:2009 application server listening at port: #{port()}.~n"
      :io.format "JSON Schema: draft-07, FHIR Protocol Version: R5/135.~n"
      Supervisor.start_link(children, opts)
  end
end
