defmodule HL7.Segment.Default.IN1 do
  @moduledoc "6.5.6 IN1 - insurance segment"
  use HL7.Segment.Spec

  require HL7.Composite.Default.CE, as: CE
  require HL7.Composite.Default.CM_IN1_14, as: CM_IN1_14
  require HL7.Composite.Default.CX, as: CX

  segment "IN1" do
    field :set_id,                         seq:  1, type: :integer, len: 4
    field :plan_id,                        seq:  2, type: {CE, :id}, len: 20
    field :plan_name,                      seq:  2, type: {CE, :text}, len: 30
    field :company_id,                     seq:  3, type: {CX, :id}, len: 6
    field :company_assigning_authority_id, seq:  3, type: {CX, :assigning_authority, :namespace_id}, len: 10
    field :company_id_type,                seq:  3, type: {CX, :id_type}, len: 10
    field :authorization_number,           seq: 14, type: {CM_IN1_14, :number}, len: 20
    field :authorization_date,             seq: 14, type: {CM_IN1_14, :date}, len: 8
  end
end
