defmodule HL7.Segment.Default.QPD do
  @moduledoc "5.5.3 QPD - query parameter definition - procedure totals"
  use HL7.Segment.Spec

  require HL7.Composite.Default.CE, as: CE
  require HL7.Composite.Default.CM_QPD_3, as: CM_QPD_3
  require HL7.Composite.Default.CX, as: CX

  segment "QPD" do
    field :query_id,                   seq:  1, type: {CE, :id}, len: 20
    field :query_name,                 seq:  1, type: {CE, :text}, len: 30
    field :query_tag,                  seq:  2, type: :string, len: 32
    field :provider_id,                seq:  3, type: {CM_QPD_3, :id}, len: 15
    field :provider_id_type,           seq:  3, type: {CM_QPD_3, :id_type}, len: 4
    field :start_date,                 seq:  4, type: :datetime, len: 12
    field :end_date,                   seq:  5, type: :datetime, len: 12
    field :procedure_id,               seq:  6, type: {CE, :id}, len: 30
    # FIXME: Is `:coding_system` the correct field in the CE composite?
    field :procedure_coding_system,    seq:  6, type: {CE, :text}, len: 8
    field :authorizer_id,              seq:  7, type: {CX, :id}, len: 6
  end
end
