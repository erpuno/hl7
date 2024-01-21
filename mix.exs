defmodule HL7.Mixfile do
  use Mix.Project

  def project do
    [ app: :hl7,
      version: "1.0.0",
      elixir: ">= 1.6.0",
      description: "HL7 FHIR Application Server",
      deps: deps(),
      package: package(),
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
      {:json_xema, "~> 0.3"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.2"}
    ]
  end

  def package do
    [ files: ["lib", "mix.exs", "README.md", "LICENSE", "NOTICE"],
      maintainers: ["Namdak Tonpa"],
      licenses: ["ISC"],
      links: %{"GitHub" => "https://github.com/erpuno/hl7"}
    ]
  end
end
