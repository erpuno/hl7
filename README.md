# ISO/HL7: FHIR Application Server

## Features

* Fast (<5ms) JSON Schema Draft 7 Circular Validator 
* FHIR Protocol Version R5
* HTTP Endpoints
* Erlang Records Internal Representation
* Extremely Compact Codebase (<5K LOC)

### Setup

```elixir
$ mix deps.get
$ iex -S mix
ISO/HL7 27931:2009 application server listening at port: 9234.
JSON Schema: Draft-07, FHIR Protocol Version: R5.
Interactive Elixir (1.12.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
```

Validation (μs):

```elixir
[
   {281, "Identifier"},
   {117, "Quantity"},
   {47, "Reference"},
   {231, "Location"},
   {385, "Extension"},
   {1129, "Patient"},
   {453, "Specimen"},
   {1178, "Observation"},
   {2088, "List"},
   {1234, "Encounter"},
   {499, "Contract"},
   {891, "Device"},
   {377, "Organization"},
   {1529, "DeviceDefinition"},
   {1814, "DeviceAssociation"},
   {378, "DetectedIssue"},
   {2068, "BodyStructure"}
]
```

## HL7/FHIR Protocol Modules

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
`Immunization`, `ImmunizationEvaluation`, `ImmunizationRecommendation`

### Financial

Financial data types: `Account`, `Contract`, `Claim`, `Enrollment`, `Coverage`, `PaymentNotice`.

## Credits

* Namdak Tonpa
