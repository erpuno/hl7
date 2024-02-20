defmodule HL7.Application do
  use Application
  def port, do: Application.get_env(:hl7, :port, 9234)
  def banner() do
      :io.format "ISO/HL7 27931:2009 application server listening at port: #{port()}.~n"
      :io.format "JSON Schema: draft-07, FHIR Protocol Version: 5.0.0.~n"
  end
  def start(_, _) do
      children = [ { Bandit, scheme: :http, plug: HL7.Endpoint, port: port() } ]
      opts = [strategy: :one_for_one, name: App.Supervisor]
      banner()
      Supervisor.start_link(children, opts)
  end
end
