-ifndef(PATIENT_HL7).
-define(PATIENT_HL7, true).

-record('Patient', {
  id = [] :: list() | binary(),
  addresses = [] :: list(),
  authenticationMethods = [],
  birthCountry = [],
  birthDate = [],
  birthSettlement = [],
  documents = [],
  email = [],
  emergencyContact = [],
  firstName = [] :: list() | binary(),
  secondName = [],
  lastName = [],
  gender = [] :: list() | binary(),
  phones = [] :: list(),
  preferredWayCommunication = email :: atom(),
  processDisclosureDataConsent = true :: boolean(),
  secret = [],
  taxId = [],
  unzr = []
}).

-endif.
