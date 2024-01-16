-ifndef(DEVICE_HL7).
-define(DEVICE_HL7, true).

-record('Device', {
  id = [],
  inventory = [],
  serial = [],
  definition = [],
  status = [],
  error = [],
  available = [],
  manufacturer = [],
  manufacturerDate = [],
  deviceName = [],
  deviceType = [],
  model = [],
  properties = [],
  patientAssociation = [],
  patient = [],
  owner = [],
  division = [],
  note = [],
  parent = [],
  insertedAt = [],
  insertedBy = [],
  updatedAt = [],
  updatedBy = [],
  recorder = [],
  encounter = [],
  lot = [],
  expire = []
}).

-endif.
