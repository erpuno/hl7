defmodule HL7.Segment.Default.RCP do
  @moduledoc "5.5.5 RCP - response control parameter segment"
  use HL7.Segment.Spec

  require HL7.Composite.Default.CE, as: CE
  require HL7.Composite.Default.CQ, as: CQ

  segment "RCP" do
    field :query_priority,       seq:  1, type: :string, len: 1
    field :response_limit,       seq:  2, type: {CQ, :quantity}, len: 10
    field :response_unit,        seq:  2, type: {CQ, :units, :id}, len: 2
    field :response_modality_id, seq:  3, type: {CE, :id}, len: 10
    field :execution_datetime,   seq:  4, type: :datetime, len: 12
    field :sort_by,              seq:  6, type: :string, len: 512
  end
end
