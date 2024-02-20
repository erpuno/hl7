defmodule HL7.Mixfile do
  use Mix.Project

  def project do
    [ app: :hl7,
      version: "1.0.2",
      elixir: ">= 1.9.0",
      description: "ISO/HL7 FHIR Application Server",
      deps: deps(),
      package: package(),
      releases: [release: [include_executables_for: [:unix], cookie: "ERP1:FHIR"]]
    ]
  end

  def package do
    [ files: ["lib", "include", "priv", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Namdak Tonpa"],
      licenses: ["ISC"],
      links: %{"GitHub" => "https://github.com/erpuno/hl7"}
    ]
  end

  def application do
    [ extra_applications: [:logger, :bandit],
      mod: {HL7.Application,[]}
    ]
  end

  def deps do
    [
      {:ex_doc, "~> 0.21", only: :dev},
      {:plug, "~> 1.15.3"},
      {:bandit, "~> 1.0"},
      {:jason, "~> 1.2"}
    ]
  end

end
