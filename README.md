# ISO/HL7: FHIR Application Server

[![Hex pm](http://img.shields.io/hexpm/v/hl7.svg?style=flat&x=1)](https://hex.pm/packages/hl7)

Minimalistic scalable microseconds precise FHIR application server in Elixir.

## Features

* Extremely Compact Codebase (<10K LOC)
* Erlang Records Internal Representation (for type-checking and compact footprint)
* Fast (<5ms) JSON Schema `draft-07` Mutual Dependency Validator
* FHIR Protocol Version R5 (160 resource types)
* FHIR Terminology (50 code systems)
* HTTP Endpoints

### Setup

```elixir
$ mix deps.get
$ iex -S mix
ISO/HL7 27931:2009 application server listening at port: 9234.
JSON Schema: draft-07, FHIR Protocol Version: R5.
Interactive Elixir (1.12.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
```

Validation (μs):

```elixir
> HL7.Validation.test
  ...
  ],
  [
    {:Person, 1071, "OK"},
    {:PlanDefinition, 4544, "OK"},
    {:PlanDefinition, 20023, "OK"},
    {:Practitioner, 721, "OK"},
    {:PractitionerRole, 2167, "OK"},
    {:Procedure, 1065, "OK"},
    {:ProcedureRequest, 2598, "OK"},
    {:Provenance, 2510, "OK"},
    {:Quantity, 351, "OK"},
    {:Questionnaire, 3633, "OK"},
    {:QuestionnaireResponse, 1215, "OK"},
    {:Reference, 749, "OK"},
    {:Schedule, 876, "OK"},
    {:SearchParameter, 4247, "OK"},
    {:Sequence, 3199, "OK"},
    {:Slot, 879, "OK"},
    {:Specimen, 1166, "OK"},
    {:Subscription, 554, "OK"},
    {:Substance, 690, "OK"},
    {:SupplyDelivery, 1278, "OK"},
    {:SupplyRequest, 9064, "OK"},
    {:Task, 50683, "OK"},
    {:TerminologyCapabilities, 3249, "OK"},
    {:TriggerDefinition, 1955, "OK"},
    {:ValueSet, 1616, "OK"},
    {:VisionPrescription, 2435, "OK"}
  ]
]
```

Note that `List` instance is 64K JSON object.
Note that best possible (fastest) validation at a given platform
can only be achieved with a validation code compiler.

## HL7/FHIR HTTP API

### Meta

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

### Validation

```sh
$ time curl -X POST "http://localhost:9234/List/\$validate" -d @samples/List/List.json
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
`Ratio`, `Range`, `RatioRange`, `Reference`, `SampledData`, `Timing`.

### Foundation

Infrastructural types: `Resource`, `DomainResource`, `Basic`, `Bundle`,
`Composition`, `List`, `Subscription`, `Endpoint`, `ServiceDefinition`.

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

Workflow modeling data types: `ActivityDefinition`, `Definition`, `EventDefinition`,
`MessageDefinition`, `PlanDefinition`, `ObservationDefinition`, `ClinicalUse`,
`Measure`, `OperationDefinition`, `Requirements`.

## Credits

# Development Environment

```elixir
IEx.configure(width: :erlang.element(2, :io.columns))
IEx.configure(inspect: [limit: :infinity])
```

* Namdak Tonpa
