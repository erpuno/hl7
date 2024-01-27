# ISO/HL7: FHIR Application Server

Minimalistic scalable microseconds precise FHIR application server in Elixir.

## Features

* Fast (<5ms) JSON Schema Draft 7 Circular Validator 
* FHIR Protocol Version R5 (100/155 types supported)
* HTTP Endpoints
* Erlang Records Internal Representation (for type-checking and compact memory footprint)
* Extremely Compact Codebase (<10K LOC)

### Setup

```elixir
$ mix deps.get
$ iex -S mix
ISO/HL7 27931:2009 application server listening at port: 9234.
JSON Schema: Draft-07, FHIR Protocol Version: R5.
Interactive Elixir (1.12.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> :application.which_applications
[
  {:hl7, 'ISO/HL7 FHIR Application Server', '1.0.0'},
  {:jsone, 'A JSON parser.\n', '1.5.1'},
  {:plug_cowboy, 'A Plug adapter for Cowboy', '2.6.2'},
  {:cowboy_telemetry, 'Telemetry instrumentation for Cowboy', '0.4.0'},
  {:cowboy, 'Small, fast, modern HTTP server.', '2.10.0'},
  {:ranch, 'Socket acceptor pool for TCP protocols.', '1.8.0'},
  {:cowlib, 'Support library for manipulating Web protocols.', '2.12.1'},
  {:plug, 'Compose web applications with functions', '1.15.3'},
  {:telemetry, 'Dynamic dispatching library for metrics and instrumentations', '1.2.1'},
  {:plug_crypto, 'Crypto-related functionality for the web', '2.0.0'},
  {:mime, 'A MIME type module for Elixir', '2.0.5'},
  {:eex, 'eex', '1.12.2'},
  {:logger, 'logger', '1.12.2'},
  {:hex, 'hex', '2.0.6'},
  {:inets, 'INETS  CXC 138 49', '7.5'},
  {:ssl, 'Erlang/OTP SSL application', '10.6.1'},
  {:public_key, 'Public key infrastructure', '1.11.3'},
  {:asn1, 'The Erlang ASN1 compiler version 5.0.17', '5.0.17'},
  {:crypto, 'CRYPTO', '5.0.5'},
  {:mix, 'mix', '1.12.2'},
  {:iex, 'iex', '1.12.2'},
  {:elixir, 'elixir', '1.12.2'},
  {:compiler, 'ERTS  CXC 138 10', '8.0.4'},
  {:stdlib, 'ERTS  CXC 138 10', '3.17'},
  {:kernel, 'ERTS  CXC 138 10', '8.2'}
]
```

Validation (μs):

```elixir
 [
   {201, "Identifier"},
   {193, "Quantity"},
   {174, "Reference"},
   {557, "Location"},
   {869, "Extension"},
   {463, "Patient"},
   {695, "Specimen"},
   {571, "Observation"},
   {2175, "List"},
   {417, "Encounter"},
   {1435, "Contract"},
   {369, "Device"},
   {885, "Organization"},
   {787, "DeviceDefinition"},
   {873, "DeviceAssociation"},
   {392, "DetectedIssue"},
   {441, "BodyStructure"}
 ]
```

Note that `List` instance is 64K JSON object.

## HL7/FHIR HTTP API

```elixir
defmodule HL7.Endpoint do
  use Plug.Router
  plug Plug.Logger
  plug :match
  plug :dispatch
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  get  "/"       do HL7.Service.root(conn) end
  post "/"       do HL7.Service.postRoot(conn) end
  get  "/$meta"      do HL7.Service.meta(conn) end
  post "/$meta"      do HL7.Service.postMeta(conn) end
  get  "/metadata"   do HL7.Service.metadata(conn) end
  get  "/_history"   do HL7.Service.history(conn) end
  get  "/_diff"      do HL7.Service.diff(conn) end
  get  "/$export"    do HL7.Service.export(conn) end
  post "/$export"    do HL7.Service.postExport(conn) end
  post "/$diff"      do HL7.Service.postDiff(conn) end
  post "/$reindex"   do HL7.Service.reindex(conn) end
  post  ":type/$validate" do HL7.Service.post4(conn,"",type,"","$validate") end
  get  ":type/:id"        do HL7.Service.get4(conn,"",type,id,"$base") end
  put  ":type/:id"        do HL7.Service.put4(conn,"",type,id,"$base") end
  delete ":type/:id"      do HL7.Service.delete4(conn,"",type,id,"$base") end
  post "/_search"                do HL7.Service.post2(conn,"","_search") end
  post "/:res/_search"           do HL7.Service.post3(conn,"",res,"_search") end
  post "/:comp/:id/_search"      do HL7.Service.post4(conn,"",comp,id,"_search") end
  post "/:comp/:id/:res/_search" do HL7.Service.post5(conn,"",comp,id,res,"_search") end
  match _ do send_resp(conn, 404,
       "Please refer to https://hl7.erp.uno manual" <>
       " for information about endpoints addresses.") end
end
```

```sh
$ curl -X GET "http://localhost:9234/\$meta"
[
  {
    "parameters": [
      {
        "name": "return",
        "valueMeta": {
          "profile": [
            "https://hl7.erp.uno/schema/Person.schema.json",
            "https://hl7.erp.uno/schema/Patient.schema.json",
            "https://hl7.erp.uno/schema/Organization.schema.json",
            "https://hl7.erp.uno/schema/Location.schema.json"
          ],
          "security": [
            {
              "code": "N",
              "display": "normal",
              "system": "https://hl7.erp.uno/CodeSystem/v4"
            }
          ],
          "tag": [
            {
              "code": "N",
              "display": "normal",
              "system": "https://hl7.erp.uno/tag/"
            }
          ]
        }
      }
    ],
    "resourceType": "Parameters"
  }
]
```

```sh
$ time curl -X POST "http://localhost:9234/List/\$validate" -d @samples/json/List/List.json
{
  "base": "",
  "id": "01111313-long",
  "spec": "$validate",
  "type": "List",
  "verify": {
    "code": "success",
    "message": "Object conforms to List of R5 schema."
  }
}
real    0m0.011s
user    0m0.005s
sys     0m0.000s
```

## HL7/FHIR R5 Protocol Modules

* General
* Foundation
* Security
* Terminology
* Administration
* Clinical
* Diagnostic
* Medications
* Financial
* Workflow

### Primitive

Internal data types: `instant`, `time`, `date`, `dateTime`, `base64binary`, `decimal`,
`integer64`, `boolean`, `url`, `code`, `string`, `integer`, `uri`, `canonical`,
`markdown`, `id`, `oid`, `uuid`, `unsignedInt`, `positiveInt`.

### General

General-purpose types: `Address`, `Age`, `Annotation`, `Attachment`, 
`ContactPoint`, `Count`, `Distance`, `Dosage`, `Duration`, `Element`,
`HumanName`, `Identifier`, `Meta`, `Money`, `Period`, `Quantity`,
`Ratio`, `Range`, `RatioRange`, `Reference`, `SampledData`, `Signature`, `Timing`.

### Foundation

Infrastructural types: `Resource`, `DomainResource`, `Basic`, `Bundle`,
`Composition`, `List`, `Subscription`.

### Security

Security-sensitive types: `Consent`, `Permission`, `Provenance`, `Signature`.

### Terminology

Dictionary-related types: `CodeSystem`, `ValueSet`, `ConceptMap`, `NamingSystem`,
`Coding`, `CodeableConcept`, `CodeableReference`, `Coding`.

### Administration

Administrative types: `Patient`, `RelatedPerson`, `Person`, `Group`, `Practitioner`,
`PractitionerRole`, `Organization`, `Account`, `Location`, `HealthcareService`,
`Endpoint`, `Schedule`, `Slot`, `SpecimenDefinition`, `EpisodOfCare`, `Encounter`,
`EncounterHistory`, `Appointment`, `Flag`, `ObservationDefinition`, `NutritionProduct`,
`Device`, `DeviceDefinition`, `DeviceMetric`, `DeviceUsage`, `DeviceAssociation`.

### Clinical

Clinical data types: `Condition`, `Procedure`, `CarePlan`, `Goal`, `DetectedIssue`.

### Diagnostic

Diagnostic data types: `Observation`, `Specimen`, `BodyStructure`.

### Medications

Medications types: `Medication`, `MedicationDispense`, `MedicationRequest`,
`MedicationStatement`, `MedicationAdministration`,
`Immunization`, `ImmunizationEvaluation`, `ImmunizationRecommendation`.

### Financial

Financial data types: `Account`, `Contract`, `Claim`, `Enrollment`, `Coverage`, `PaymentNotice`.

### Workflow

Workflow modeling data types: `ActivityDefinition`, `Definition`, `EventDefinition`, `MessageDefinition`, `PlanDefinition`, `ObservationDefinition`, `ClinicalUse`, `Measure`, `OperationDefinition`, `Requirements`.

## Credits

* Namdak Tonpa
