# ISO/HL7: FHIR Application Server

Minimalistic scalable microseconds-precise FHIR application server in Elixir.

## Features

* Fast (<5ms) JSON Schema Draft 7 Circular Validator 
* FHIR Protocol Version R5 (90/155 supported)
* HTTP Endpoints
* Erlang Records Internal Representation
* Extremely Compact Codebase (<10K LOC)

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

## Credits

* Namdak Tonpa
