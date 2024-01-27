-ifndef(PERSON_HL7).
-define(PERSON_HL7, true).

-record('Person', {
  id = [] :: list() | binary(),
  firstName = [] :: list() | binary(),
  secondName = [],
  lastName = [],
  birthDate = [] :: [] | calendar:datetime(),
  gender = [] :: list() | binary(),
  emergencyContact = [],
  externalId = [],
  note = [],
  taxId = [],
  status = [],
  deathDate = [],
  isActive = true :: boolean()
}).

-endif.
