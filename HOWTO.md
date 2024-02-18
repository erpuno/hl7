ISO/HL7 FHIR Maintenance Shell
------------------------------

```elixir
$ sudo apt install elixir
$ mix deps.get
$ iex -S mix
>
```

Compound Dictionaries
---------------------

```elixir
> HL7.Validation.showValueSet "CareTeamCategory"
{"CareTeamCategory", :ok, "care-team-category", "http://hl7.org/fhir/ValueSet/care-team-category",
 [
   {1, "http://loinc.org", :"LA27975-4", "Event-focused care team"},
   {1, "http://loinc.org", :"LA27976-2", "Encounter-focused care team"},
   {1, "http://loinc.org", :"LA27977-0", "Episode of care-focused care team"},
   {1, "http://loinc.org", :"LA27978-8", "Condition-focused care team"},
   {1, "http://loinc.org", :"LA28865-6", "Longitudinal care-coordination focused care team"},
   {1, "http://loinc.org", :"LA28866-4", "Home & Community Based Services (HCBS)-focused care team"},
   {1, "http://loinc.org", :"LA27980-4", "Clinical research-focused care team"},
   {1, "http://loinc.org", :"LA28867-2", "Public health-focused care team"},
   {1, "http://snomed.info/sct", :"102002", "Hemoglobin Okaloosa"},
   {1, "http://snomed.info/sct", :"120006", "Ornithine racemase"}
 ]}
```

Registered Terminologies
------------------------

```elixir
> HL7.Validation.showTerminology "ЕСОЗ"
{"ЕСОЗ", :ok, [%{"system" => "urn:ietf:rfc:3986", "value" => "urn:oid:2.16.840.1.113883.4.642.6.1"}], %{"description" => "The ACME FHIR Terminology Server"},
 [
   {"http://snomed.info/sct", [%{"code" => "http://snomed.info/sct/32506021000036107/version/20220831"}], "complete"},
   {"http://loinc.org", [%{"code" => "2.73"}], "complete"}
 ]}

```

Hierarchical Dictionaries
-------------------------

```elixir
> HL7.Validation.showCodeSystem "FHIRVersion"
{"FHIRVersion", :ok, "FHIR-version", "http://hl7.org/fhir/FHIR-version",
 [
   {1, nil, :"3.0", "3.0"},
   {2, nil, :"3.0.0", "3.0.0"},
   {2, nil, :"3.0.1", "3.0.1"},
   {2, nil, :"3.0.2", "3.0.2"},
   {1, nil, :"3.3", "3.3"},
   {2, nil, :"3.3.0", "3.3.0"},
   {1, nil, :"3.5", "3.5"},
   {2, nil, :"3.5.0", "3.5.0"},
   {1, nil, :"4.0", "4.0"},
   {2, nil, :"4.0.0", "4.0.0"},
   {2, nil, :"4.0.1", "4.0.1"},
   {1, nil, :"4.1", "4.1"},
   {2, nil, :"4.1.0", "4.1.0"},
   {1, nil, :"4.2", "4.2"},
   {2, nil, :"4.2.0", "4.2.0"},
   {1, nil, :"4.3", "4.3"},
   {2, nil, :"4.3.0", "4.3.0"},
   {2, nil, :"4.3.0-cibuild", "4.3.0-cibuild"},
   {2, nil, :"4.3.0-snapshot1", "4.3.0-snapshot1"},
   {1, nil, :"4.4", "4.4"},
   {2, nil, :"4.4.0", "4.4.0"},
   {1, nil, :"4.5", "4.5"},
   {2, nil, :"4.5.0", "4.5.0"},
   {1, nil, :"4.6", "4.6"},
   {2, nil, :"4.6.0", "4.6.0"},
   {1, nil, :"5.0", "5.0"},
   {2, nil, :"5.0.0", "5.0.0"},
   {3, nil, :"5.0.0-cibuild", "5.0.0-cibuild"},
   {3, nil, :"5.0.0-snapshot1", "5.0.0-snapshot1"},
   {3, nil, :"5.0.0-snapshot2", "5.0.0-snapshot2"},
   {3, nil, :"5.0.0-ballot", "5.0.0-ballot"},
   {3, nil, :"5.0.0-snapshot3", "5.0.0-snapshot3"},
   {3, nil, :"5.0.0-draft-final", "5.0.0-draft-final"}
 ]}
```

Registered Distributed Domains
------------------------------

```elixir
> HL7.Validation.showCodeSystem "CodeSystem"
{"CodeSystem", :ok, [%{"FHIR" => "CodeSystem"}], "http://terminology.hl7.org/CodeSystem/v3-CodeSystem",
 [
   {1, "ДССУ:КОАТУУ/SETTLEMENT_TYPE", :КОАТУУ, "Вид населенного пункту КОАТУУ"},
   {1, "ДССУ:КАТОТТГ/SETTLEMENT_TYPE", :КАТОТТГ, "Вид населенного пункту КАТОТТГ"},
   {1, "ДССУ:КВЕД", :КВЕД, "Класифікація видів економічної діяльності (КВЕД)"},
   {1, "ЕСОЗ:LEGAL_ENTITY_TYPE", :OrganizationType, "Технічний тип системи організації"},
   {1, "ЕСОЗ:LEGAL_ENTITY_TYPE_V2", :OrganizationType, "Технічний тип системи організації (нові поля)"},
   {1, "ЕСОЗ:LEGAL_ENTITY_STATUS", :OrganizationStatus, "Технічний статус організації"},
   {1, "ЕСОЗ:LEGAL_FORM", :OrganizationForm, "Юридичний тип системи (форма власності)"},
   {1, "ЕСОЗ:DIVISION_STATUS", :LocationStatus, "Статус структурного підрозділу"},
   {1, "ЕСОЗ:MEDICATION_UNIT", :UnitOfPresentation, "Спосіб розповсюдження лікарського засобу"},
   {1, "ЕСОЗ:COUNTRY", :Country, "Міжнародні коди країн"},
   {1, "ЕСОЗ:eHealth/immunization_dosage_units", :DosageUnits, "Одиниці виміру доз для імунізації"},
   {1, "ЕСОЗ:eHealth/ICPC2/reasons", :ICPC2UKR, "Класифікатор первинної медичної допомоги"},
   {1, "ЕСОЗ:eHealth/ICPC2/actions", :"ICPC2UKR-actions", "Класифікатор дій первинної медичної допомоги"},
   {1, "ЕСОЗ:eHealth/episode_types", :EpisodeOfCareType, "Види медичної допомоги"},
   {1, "FHIR:CodeSystem", :CodeSystem, "Цей класифікатор ієрархічних словників FHIR сервера"},
   {1, "FHIR:ActionType", :ActionType, "Type of CRUD operation or Event signalling"},
   {1, "FHIR:BundleType", :BundleType, "Type of Bundle of FHIR server"},
   {1, "FHIR:Religion2", :Religion2, "Type of Religion of FHIR nomenclature"},
   {1, "FHIR:RefferalStatus", :RefferalStatus, "Status of Document in CRM"},
   {1, "FHIR:ActionCode", :ActionCode, "Type of message in CRM system describing Practitioner action"},
   {1, "FHIR:AdministrativeGender", :AdministrativeGender, "Gender or person"},
   {1, "FHIR:AdministrableDoseForm", :AdministrableDoseForm, "Dose form for a medication, in the form suitable for patient"},
   {1, "FHIR:AllergyIntoleranceCategory", :AllergyIntoleranceCategory, "Category of an identified substance associated with allergies or intolerances"},
   {1, "FHIR:AllergyIntoleranceType", :AllergyIntoleranceType, "Identification of the underlying physiological mechanism for a Reaction Risk"},
   {1, "FHIR:AllergyIntoleranceCriticality", :AllergyIntoleranceCriticality, "Estimate of the potential clinical harm of a reaction to an identified substance"},
   {1, "FHIR:AppointmentStatus", :AppointmentStatus, "Type of Patient appointment in history records of scheduled visits"},
   {1, "FHIR:ObservationCategory", :ObservationCategory, "ObservationCategory"},
   {1, "FHIR:FHIRTypes", :FHIRTypes, "List of supported JSON Schema definitions by this FHIR server"},
   {1, "FHIR:FHIRVersion", :FHIRVersion, "List of known FHIR versions"},
   {1, "FHIR:Eligibility", :Eligibility, "List of HealthcareService eligibility codes"},
   {1, "FHIR:BodyParts", :BodyParts, "Concepts specifying the part of the body"},
   {1, "FHIR:DetectedIssueSeverity", :DetectedIssueSeverity, "Potential degree of impact of the identified issue for Patient"},
   {1, "FHIR:DeviceAssociationStatus", :DeviceAssociationStatus, "DeviceAssociation Status Codes"},
   {1, "FHIR:DeviceAvailabilityStatus", :DeviceAvailabilityStatus, "The record status of the device"},
   {1, "FHIR:DeviceCategory", :DeviceCategory, "The category of the device"},
   {1, "FHIR:DeviceDefinitionRelationType", :DeviceDefinitionRelationType, "The type of relation between devices"},
   {1, "FHIR:DeviceDispenseStatusCodes", :DeviceDispenseStatusCodes, "DeviceDispense Status Codes"},
   {1, "FHIR:DeviceNameType", :DeviceNameType, "The type of name the device is referred by"},
   {1, "FHIR:DeviceRegulatoryIdentifierType", :DeviceRegulatoryIdentifierType, "Device Regulatory Identifier Type"},
   {1, "FHIR:DeviceSpecializationCategory", :DeviceSpecializationCategory, "The kind of standards used by the device"},
   {1, "FHIR:DeviceStatus", :DeviceStatus, "The status of the Device record"},
   {1, "FHIR:DeviceUsageAdherenceCode", :DeviceUsageAdherenceCode, "Device Usage Adherence Code"},
   {1, "FHIR:DeviceUsageAdherenceReason", :DeviceUsageAdherenceReason, "Device Usage Adherence Reason"},
   {1, "FHIR:DeviceUsageStatus", :DeviceUsageStatus, "A coded concept indicating the current status of the Device Usage"},
   {1, "FHIR:IssueType", :IssueType, "A code that describes the type of issue"},
   {1, "FHIR:GoalStatus", :GoalStatus, "Codes that reflect the current state of a goal"},
   {1, "FHIR:ItemType", :ItemType, "Distinguishes groups from questions and display text"}
 ]}
```
