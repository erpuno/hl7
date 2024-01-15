Contract
--------

```json
{
  "start_date": "2017-04-20",
  "end_date": "2017-04-20",
  "status": "VERIFIED",
  "contractor_legal_entity_id": "56440c03-e218-432a-b417-9574b2b287bd",
  "contractor_owner_id": "54fea667-62cf-4688-ae9e-31acc19d986d",
  "contractor_base": "на підставі закону про Медичне обслуговування населення",
  "contractor_payment_details": {
    "bank_name": "Банк номер 1",
    "MFO": "351005",
    "payer_account": "32009102701026"
  },
  "contractor_rmsp_amount": 50000,
  "external_contractor_flag": true,
  "external_contractors": [
    {
      "legal_entity": {
        "id": "b075f148-7f93-4fc2-b2ec-2d81b19a9b7b",
        "name": "Клініка Ноунейм"
      },
      "contract": {
        "number": "1234567",
        "issued_at": "2018-01-01",
        "expires_at": "2019-01-01"
      },
      "divisions": [
        {
          "id": "2922a240-63db-404e-b730-09222bfeb2dd",
          "name": "Бориспільське відділення Клініки Ноунейм",
          "medical_service": "Послуга ПМД"
        }
      ]
    }
  ],
  "nhs_signer_id": "da8cc932-7bca-4048-a3ff-9b07f901a860",
  "nhs_signer_base": "на підставі наказу",
  "nhs_legal_entity_id": "e5f76afb-4d96-4279-bcf1-0308457e6b64",
  "nhs_payment_method": "BACKWARD",
  "is_suspended": false,
  "issue_city": "Київ",
  "nhs_contract_price": 50000,
  "contract_number": "0000-9EAX-XT7X-3115",
  "status_reason": "default",
  "parent_contract_id": "09106b70-18b0-4726-b0ed-6bda1369fd52",
  "id_form": "PMD",
  "nhs_signed_date": "2017-04-20",
  "type": "CAPITATION",
  "reason": "не було виконано умов контракту",
  "signed_content_location": "bucket_name/folder_identifier/file_name"
}
```