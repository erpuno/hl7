defmodule HL7.Validation do

  def suite() do
      [
        :Identifier, :Quantity, :Reference, :Location, :Extension, :Patient, :Specimen, :Observation,
        :List, :Encounter, :Contract, :Device, :Organization, :DeviceDefinition, :DeviceAssociation,
        :DeviceMetric, :DeviceRequest, :DeviceDispense, :DetectedIssue, :BodyStructure, :Account,
        :AdverseEvent, :CarePlan, :CareTeam, :AllergyIntolerance, :Appointment, :AppointmentResponse,
        :AuditEvent, :Binary, :Bundle, :BodyStructure, :CapabilityStatement, :Claim, :ClaimResponse,
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
        :PlanDefinition, :Practitioner, :PractitionerRole, :Procedure, :ProcedureRequest,
        :Substance, :Medication, :OperationOutcome
      ]
  end

  def clear_cache() do
      :lists.flatten(
      :lists.map(fn {y,_} when is_binary(y) ->
        :application.set_env(:hl7, y, [])
        {y}
        ; _ -> [] end,
      :application.get_all_env(:hl7)))
  end

  def split(array) do :lists.split(:erlang.div(:erlang.length(array),2),array) end

  def test() do
      _ = :lists.map fn x ->
          {time,_} = :timer.tc(fn -> HL7.Loader.loadSchema "#{x}" end)
          :io.format 'load: ~p (μs), file: ~ts.~n', [time,"#{x}"]
          {time,x}
      end, suite()
      s = :lists.sort :lists.map fn x ->
          {time,{name,code}} = :timer.tc(fn -> testItem "#{x}" end)
          :io.format 'validation: ~p (μs), schema: ~ts.~n', [time,"#{name}"]
          {status(code),:erlang.binary_to_atom(name),time}
      end, suite()
      {x,y} = split(s)
      {a,b} = split(x)
      {c,d} = split(y)
      [a,b,c,d] # R5/135
  end

  def status(:ok) do "OK" end
  def status({:error, %Xema.ValidationError{reason: %{all_of: x}}}) do x end

  def testItem(name) do
      file = "samples/json/#{name}/#{name}.json"
      {_,objBin} = :file.read_file file
      schema = HL7.Loader.loadSchema("#{name}")
      obj = Jason.decode!(objBin)
      verify = Xema.validate(schema, obj)
      {name,verify}
  end

end
