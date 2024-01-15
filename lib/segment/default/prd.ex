defmodule HL7.Segment.Default.PRD do
  @moduledoc "11.6.3 PRD - provider data segment"
  use HL7.Segment.Spec

  require HL7.Composite.Default.CE, as: CE
  require HL7.Composite.Default.CM_PRD_7, as: CM_PRD_7
  require HL7.Composite.Default.XAD, as: XAD
  require HL7.Composite.Default.XPN, as: XPN

  segment "PRD" do
    field :role_id,                   seq:  1, rep: 1, type: {CE, :id}, len: 5
    field :role_name,                 seq:  1, rep: 1, type: {CE, :text}, len: 30
    field :role_coding_system,        seq:  1, rep: 1, type: {CE, :coding_system}, len: 7
    field :specialty_id,              seq:  1, rep: 2, type: {CE, :id}, len: 5
    field :specialty_name,            seq:  1, rep: 2, type: {CE, :text}, len: 30
    field :specialty_coding_system,   seq:  1, rep: 2, type: {CE, :coding_system}, len: 7
    field :last_name,                 seq:  2, type: {XPN, :family_name, :surname}, len: 40
    field :first_name,                seq:  2, type: {XPN, :given_name}, len: 30
    field :street,                    seq:  3, type: {XAD, :street_address}, len: 20
    field :other_designation,         seq:  3, type: {XAD, :other_designation}, len: 20
    field :city,                      seq:  3, type: {XAD, :city}, len: 30
    field :state,                     seq:  3, type: {XAD, :state}, len: 1
    field :postal_code,               seq:  3, type: {XAD, :postal_code}, len: 10
    field :country_code,              seq:  3, type: {XAD, :country}, len: 3
    field :address_type,              seq:  3, type: {XAD, :address_type}, len: 1
    field :provider_id,               seq:  7, type: {CM_PRD_7, :id}, len: 15
    field :provider_id_type,          seq:  7, type: {CM_PRD_7, :id_type, :license_type}, len: 2
    field :provider_id_type_province, seq:  7, type: {CM_PRD_7, :id_type, :province_id}, len: 1
    field :provider_id_alt_qualifier, seq:  7, type: {CM_PRD_7, :other}, len: 8
  end
end
