defmodule HL7.Validation do

#  def set(), do: [ :Claim ]
  def set(), do: suite()

  def suite() do
      [
        :Identifier, :Quantity, :Reference, :Location,
        :Extension, :Patient, :Specimen, :Observation,
        :List, :Encounter, :Contract, :Device, :Organization,
        :DeviceDefinition, :DeviceAssociation, :DeviceMetric, :DeviceRequest, :DeviceDispense,
        :DetectedIssue, :BodyStructure, :Account, :AdverseEvent, :CarePlan, :CareTeam,
        :AllergyIntolerance, :Appointment, :AppointmentResponse,
        :AuditEvent, :Binary, :Bundle, :BodyStructure, :CapabilityStatement,
        :Claim, :ClaimResponse, :ChargeItem, :Basic, :BodySite, :ClinicalImpression,
        :CodeSystem, :Composition, :ConceptMap, :Condition,
        :Consent, :CoverageEligibilityRequest, :CoverageEligibilityResponse,
        :DiagnosticReport, :DocumentReference, :Endpoint, :EnrollmentRequest,
        :EpisodeOfCare, :ExplanationOfBenefit, :FamilyMemberHistory, :Flag,
        :Communication, :CommunicationRequest, :CompartmentDefinition, :DataRequirement,
        :Immunization, :ImmunizationRecommendation, :Person, :TerminologyCapabilities,
        :ValueSet, :Slot, :Provenance
      ]
  end

  def cache() do
      :lists.flatten(
      :lists.map(fn {y,_} when is_binary(y) -> {y} ; _ -> [] end,
      :application.get_all_env(:hl7)))
  end

  def test() do
      x = :lists.map fn x ->
          {time,_} = :timer.tc(fn -> HL7.Loader.loadSchema "#{x}" end)
          :io.format 'load: ~p (μs), file: ~ts.~n', [time,"#{x}"]
          {time,x}
      end, set()
      y = :lists.map fn x ->
          {time,{name,code}} = :timer.tc(fn -> testItem "#{x}" end)
          :io.format 'validation: ~p (μs), schema: ~ts.~n', [time,"#{name}"]
          {time,name,status(code)}
      end, set()
      v = cache()
      {v,length(v),x,:lists.split(:erlang.div(length(y),2),y)}
  end

  def status(:ok) do :ok end
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
