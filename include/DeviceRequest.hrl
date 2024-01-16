-ifndef(DEVICEREQUEST_HL7).
-define(DEVICEREQUEST_HL7, true).

-record('DeviceRequest', {
  id = [],
  status = [],
  statusReason = [],
  intent = [],
  code = [],
  codeRef = [],
  quantity = [],
  subject = [],
  requester = [],
  encounter = [],
  reason = [],
  authoredOn = [],
  organization = [],
  location = [],
  program = [],
  requisition = [],
  dispenseValidTo = [],
  occurrencePeriod = [],
  verificationCode = [],
  contextEpisodeId = [],
  insertedAt = [],
  insertedBy = [],
  updatedAt = [],
  updatedBy = [],
  signedContentLinks = [],
  basedOn = [],
  priority = [],
  parameters = [],
  performer = [],
  supportingInfo = []
}).

-endif.
