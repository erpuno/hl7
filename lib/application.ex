defmodule HL7.Application do
  use Application
  def port, do: Application.get_env(:hl7, :port, 9234)
  def start(_, _) do
      children = [ { Plug.Cowboy, scheme: :http, plug: HL7.Endpoint, options: [port: port()] } ]
      opts = [strategy: :one_for_one, name: App.Supervisor]
      :io.format "HL7/FHIR server listening at port: #{port()}~n"
      Supervisor.start_link(children, opts)
  end
end
