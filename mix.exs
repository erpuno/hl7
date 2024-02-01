defmodule HL7.Mixfile do
  use Mix.Project

  def project do
    [ app: :hl7,
      version: "1.0.0",
      elixir: ">= 1.9.0",
      description: "ISO/HL7 FHIR Application Server",
      deps: deps(),
      package: package(),
    ]
  end

  def package do
    [ files: ["lib", "include", "priv", "schema", "samples", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Namdak Tonpa"],
      licenses: ["ISC"],
      links: %{"GitHub" => "https://github.com/erpuno/hl7"}
    ]
  end

  def application do
    [ extra_applications: [:logger, :plug_cowboy, :xmerl],
      mod: {HL7.Application,[]}
    ]
  end

  def deps do
    [
      {:ex_doc, "~> 0.21", only: :dev},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.2"}
    ]
  end

end
