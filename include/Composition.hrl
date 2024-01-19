-ifndef(COMPOSITION_HL7).
-define(COMPOSITION_HL7, true).

-record('Section', {
  code = [],
  title = [],
  author = [],
  focus = [],
  entry = [],
  text = [],
  orderedBy = [],
  emptyReason = [],
  sections = []
}).

-type sectionCode() ::
      episode_of_care | diagnostic_report | encounter | care_plan | activity |
      procedure | observation | clinical_impression | immunization |
      medication_request | ervice_request | composition | medication_dispense |
      device_request | device_dispense | legal_entity | division | employee |
      complete_diagnosis | anamnesis | diagnostic | disease_course |
      recommendations | person_data | treatment | death_reason | hospitalization_condition |
      discharge_condition.

-type compositionType() :: newBorn | tempDisability.

-type compositionCategory() ::
      childCare | covid19 | familyCare | parentalCare | liveBirth | pregnancy |
      prosthetic | quarantine | restoration | tempTransfer | sickness.

-record('Composition', {
  id = [],
  status = [],
  type = [] :: [] | compositionType(),
  category = [] :: [] | compositionCategory(),
  subject = [],
  encounter = [],
  date = [],
  author = [],
  title = [],
  confidentiality = [],
  attester = [],
  custodian = [],
  relatesTo = [],
  event = [],
  sections = [],
  extension = []
}).

-endif.
