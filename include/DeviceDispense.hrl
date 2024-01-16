-ifndef(DEVICEDISPENSE_HL7).
-define(DEVICEDISPENSE_HL7, true).

-record('DeviceDispense', {
  id = [],
  basedOn = [],
  status = [],
  subject = [],
  performer = [],
  location = [],
  handedOver = [],
  note = [],
  practitioner = [],
  organization = [],
  program = [],
  details = [], % properties
  paymentId = [],
  paymentAmount = [],
  insertedAt = [],
  insertedBy = [],
  updatedAt = [],
  updatedBy = [],
  signedContentLinks = [],
  partOf = [],
  encounter = [],
  contextEpisodeId = [],
  originEpisodeId = [],
  supportingInfo = []
}).

-endif.
