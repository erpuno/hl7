-ifndef(COMPOSITION_HL7).
-define(COMPOSITION_HL7, true).

-record('Composition', {
  id = [],
  status = [],
  type = [],     % NEWBORN, TEMP_DISABILITY
  category = [], % CHILD_CARE, COVID19, FAMILY_CARE, PARENTAL_CARE,
                 % LIVE_BIRTH, PREGNANCY, PROSTHETIC, QUARANTINE,
                 % RESTORATION, TEMP_TRANSFER, SICKNESS
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
