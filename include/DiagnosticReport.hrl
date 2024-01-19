-ifndef(DIAGNOSTIC_REPORT_HL7).
-define(DIAGNOSTIC_REPORT_HL7, true).

-record('DiagnosticReport', {
  name = [],
  addresses = [],
  phones = [],
  email = [],
  workingHours = [],
  type = [],
  legalEntityId = [],
  externalId = [],
  location = []
}).

-endif.
