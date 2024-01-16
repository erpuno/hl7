-ifndef(LOCATION_HL7).
-define(LOCATION_HL7, true).

-record('Location', {
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
