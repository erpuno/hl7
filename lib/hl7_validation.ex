defmodule HL7.Validation do

  def suite() do
      [
        :Identifier, :Quantity, :Reference, :Location, :Extension, :Patient, :Specimen, :Observation,
        :List, :Encounter, :Contract, :Device, :Organization, :DeviceDefinition, :DeviceAssociation,
        :DeviceMetric, :DeviceRequest, :DeviceDispense, :DetectedIssue, :BodyStructure, :Account,
        :AdverseEvent, :CarePlan, :CareTeam, :AllergyIntolerance, :Appointment, :AppointmentResponse,
        :AuditEvent, :Binary, :Bundle, :CapabilityStatement, :Claim, :ClaimResponse,
        :ChargeItem, :Basic, :BodySite, :ClinicalImpression, :CodeSystem, :Composition, :ConceptMap,
        :Condition, :Consent, :CoverageEligibilityRequest, :CoverageEligibilityResponse,
        :DiagnosticReport, :DocumentReference, :Endpoint, :EnrollmentRequest, :EpisodeOfCare,
        :ExplanationOfBenefit, :FamilyMemberHistory, :Flag, :Communication, :CommunicationRequest,
        :CompartmentDefinition, :DataRequirement, :Immunization, :ImmunizationRecommendation,
        :Person, :TerminologyCapabilities, :ValueSet, :Slot, :Provenance, :MeasureReport,
        :Questionnaire, :Subscription, :Parameters, :MedicationStatement, :NamingSystem, :Media,
        :VisionPrescription, :Schedule, :Sequence, :QuestionnaireResponse, :MessageDefinition,
        :MessageHeader, :NutritionOrder, :SearchParameter, :PaymentNotice, :PaymentReconciliation,
        :PlanDefinition, :SupplyDelivery, :SupplyRequest, :Task, :TriggerDefinition,
        :ActivityDefinition, :Coverage, :DeviceComponent, :DeviceUsage, :DeviceUseStatement,
        :EnrollmentResponse, :HealthcareService, :Measure, :MedicationRequest, :MedicationDispense,
        :Practitioner, :PractitionerRole, :Procedure, :ProcedureRequest,
        :Substance, :Medication, :OperationOutcome, :ExtendedContactDetail, :OrganizationAffiliation,
        :EventDefinition, :Goal, :ImagingSelection, :ImagingStudy, :MedicationAdministration,
        :MedicationKnowledge, :Contributor, :StructureDefinition, :TestScript, :TestReport, :Group,
        :Linkage, :Library, :ImplementationGuide, :ImagingManifest, :GuidanceResponse, :GraphDefinition,
        :Timing, :UsageContext, :StructureMap, :Signature, :SampledData, :ResourceList,
        :Resource, :RelatedArtifact, :MarketingStatus, :Ingredient, :ProductPackageDefinition, :Permission,
        :Invoice
      ]
  end

  def clear_cache() do
      :lists.flatten(
      :lists.map(fn {y,_} when is_binary(y) ->
#       :application.set_env(:hl7, y, [])
        {y}
        ; _ -> [] end,
      :application.get_all_env(:hl7)))
  end

  def split(array) do :lists.split(:erlang.div(:erlang.length(array),2),array) end

  def load() do
      :lists.map fn x ->
          {time,_} = :timer.tc(fn -> HL7.Loader.loadSchema "#{x}" end)
          :io.format 'load: ~p (μs), file: ~ts.~n', [time,"#{x}"]
          {time,x}
      end, suite()
  end

  def test() do
      # load()
      s = :lists.sort :lists.map fn x ->
          {time,{name,code}} = :timer.tc(fn -> testItem "#{x}" end)
          :io.format 'validation: ~p (μs), schema: ~ts.~n', [time,"#{name}"]
          {status(code),:erlang.binary_to_atom(name),time}
      end, suite()
      {x,y} = split(s)
      {a,b} = split(x)
      {c,d} = split(y)
      [a,b,c,d] # R5/160
  end

  def status(:ok) do "OK" end
  def status({:error, %Xema.ValidationError{reason: %{all_of: x}}}) do x end

  def foldConcept(_name, []), do: []
  def foldConcept(name, list) do
      res = :lists.flatten( :lists.map(fn x ->
        id = Map.get(x, "id")
        case id do
             nil when name == "CodeSystem" -> []
             _ ->
               code = :erlang.binary_to_atom Map.get(x, "code")
               display = Map.get(x, "display")
               concept = Map.get(x, "concept")
               [{id,code,display}] ++
               case concept do
                 nil -> []
                   _ -> foldConcept(code, concept)
               end
        end
      end, list))
      res
  end

  def testCodeSystem(name) do
      file = "terminology/#{name}/CodeSystem-#{name}.json"
      {_,objBin} = :file.read_file file
      schema = HL7.Loader.loadSchema("CodeSystem")
      obj = Jason.decode!(objBin)
      id = Map.get(obj, "id")
      _publisher = Map.get(obj, "publisher")
      list = Map.get(obj, "concept")
      res = :lists.flatten :lists.map(fn x ->
        code = Map.get(x, "code")
        display = Map.get(x, "display", [])
        concept = Map.get(x, "concept", [])
        id = Map.get(x, "id")
        [case id do nil when name == "CodeSystem" -> [] ; _ -> {id,:erlang.binary_to_atom(code),display} end]
        ++ foldConcept(name, concept)
       end, list)
      verify = Xema.validate(schema, obj)
      {name,verify,id,res}
  end

  def testItem(name) do
      file = "samples/json/#{name}/#{name}.json"
      {_,objBin} = :file.read_file file
#     :io.format 'loadFile: ~p~n', [file]
      schema = HL7.Loader.loadSchema("#{name}")
      obj = Jason.decode!(objBin)
      verify = Xema.validate(schema, obj)
      {name,verify}
  end

end
