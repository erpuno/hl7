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
          {time,{name,code}} = :timer.tc(fn -> testSample "#{x}" end)
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

  def foldConcept(_name, [], _lvl), do: []
  def foldConcept(name, list, lvl) do
      res = :lists.flatten( :lists.map(fn x ->
        id = Map.get(x, "id")
        case id do
             nil when name == "CodeSystem" -> []
             _ ->
               code = :erlang.binary_to_atom Map.get(x, "code")
               display = Map.get(x, "display")
               concept = Map.get(x, "concept")
               [{lvl,id,code,display}] ++
               case concept do
                 nil -> []
                   _ -> foldConcept(code, concept, lvl+1)
               end
        end
      end, list))
      res
  end

  def testCodeSystem(name) do
      lvl = 1
      file = "terminology/CodeSystem/CodeSystem-#{name}.json"
      {_,objBin} = :file.read_file file
      schema = HL7.Loader.loadSchema("CodeSystem")
      obj = Jason.decode!(objBin)
      id = Map.get(obj, "id")
      url = Map.get(obj, "url")
      list = Map.get(obj, "concept")
      res = :lists.flatten :lists.map(fn x ->
        code = Map.get(x, "code")
        display = Map.get(x, "display", [])
        concept = Map.get(x, "concept", [])
        id = Map.get(x, "id")
        [case id do nil when name == "CodeSystem" -> [] ; _ -> {lvl,id,:erlang.binary_to_atom(code),display} end]
        ++ foldConcept(name, concept, lvl + 1)
       end, list)
      verify = Xema.validate(schema, obj)
      {name,verify,id,url,res}
  end

  def testValueSet(name) do
      lvl = 1
      file = "terminology/ValueSet/ValueSet-#{name}.json"
      {_,objBin} = :file.read_file file
      schema = HL7.Loader.loadSchema("ValueSet")
      obj = Jason.decode!(objBin)
      id = Map.get(obj, "id")
      url = Map.get(obj, "url")
      compose = Map.get(obj, "compose")
      include = Map.get(compose, "include",[])
      res = :lists.flatten :lists.map(fn i ->
        system = Map.get(i, "system")
        list = Map.get(i, "concept")
        :lists.map(fn x ->
          code = Map.get(x, "code")
          display = Map.get(x, "display", [])
          concept = Map.get(x, "concept", [])
          {lvl,system,:erlang.binary_to_atom(code),display}
        end, list)
      end, include)
      verify = Xema.validate(schema, obj)
      {name,verify,id,url,res}
  end

  def testSample(name) do
      file = "samples/json/#{name}/#{name}.json"
      {_,objBin} = :file.read_file file
#     :io.format 'loadFile: ~p~n', [file]
      schema = HL7.Loader.loadSchema("#{name}")
      obj = Jason.decode!(objBin)
      verify = Xema.validate(schema, obj)
      {name,verify}
  end

  def testTerminology(name) do
      file = "terminology/TerminologyCapabilities/TerminologyCapabilities-#{name}.json"
      {_,objBin} = :file.read_file file
#     :io.format 'loadFile: ~p~n', [file]
      schema = HL7.Loader.loadSchema("TerminologyCapabilities")
      obj = Jason.decode!(objBin)
      id = Map.get(obj, "identifier")
      publisher = Map.get(obj, "implementation")
      codeSystem = Map.get(obj, "codeSystem")
      res = :lists.flatten :lists.map(fn x ->
        uri = Map.get(x, "uri")
        version = Map.get(x, "version", [])
        content = Map.get(x, "content", [])
        {uri,version,content}
       end, codeSystem)
      verify = Xema.validate(schema, obj)
      {name,verify,id,publisher,res}
  end

end
