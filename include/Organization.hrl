-ifndef(PATIENT_HL7).
-define(PATIENT_HL7, true).

-record('Organization', {
  name = [],
  shortName = [],
  publicName = [],
  type = [],
  ownerPropertyType = [],
  legalForm = [],
  edrpou = [],
  kveds = [],
  addresses = [],
  email = [],
  website = [],
  receiverFundsCode = [],
  beneficiary = [],
  owner = [], % HL7."Person"
  phones = [],
  medical_service_provider = [],
  accreditation = [],
  archive = [],
  security = [],
  public_offer = []
}).

-endif.
