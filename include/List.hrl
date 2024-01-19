-ifndef(LIST_HL7).
-define(LIST_HL7, true).

-type listEmptyReason ::
      nilknown | notasked | unavailable | notstarted | closed.

-type listCode() ::
      examinations | diary | procedures | medications |
      discharge_procedures | discharge_medications.

-record('List', {
  id = [],
  status = [],
  mode = [],
  title = [],
  code = [],
  subject = [],
  encounter = [],
  insertedAt = [],
  insertedBy = [],
  updatedAt = [],
  updatedBy = [],
  note = [],
  orderedBy = [],
  entryFlag = [],
  entryDate = [],
  entryItem = [],
  emptyReason = []
}).

-endif.
