-ifndef(DEVICEDEFINITION_HL7).
-define(DEVICEDEFINITION_HL7, true).

-record('DeviceDefinition', {
  id = [],
  externalId = [],
  description = [],
  partNumber = [],
  deviceName = [],
  deviceType = [],
  class = [],
  model = [],
  manufacturer = [],
  packageType = [],
  packageCount = [],
  packageUnit = [],
  properties = [],
  note = [],
  parentDevice = [],
  isActive = []
}).

-endif.
