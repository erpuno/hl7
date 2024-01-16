defmodule HL7.XML.Router do
  use Routes.Base

  # SYSTEM

  get "/" do
    send(conn, 200, [%{}])
  end

  get "/metadata" do
    send(conn, 200, [%{"resourceType" => "CapabilityStatement"}])
  end

  get "/_history" do
    send(conn, 200, %{})
  end

  get "/_diff" do
    send(conn, 200, %{})
  end

  get "/$meta" do
    send(conn, 200, %{ "resourceType" => "Parameters",
                       "parameters" => [
                          %{ "name" => "return",
                             "valueMeta" => %{
                                 "profile" => [
                                   "https://ehealth.gov.ua/StrudctureDefinition/Person",
                                   "https://ehealth.gov.ua/StrudctureDefinition/Patients",
                                   "https://ehealth.gov.ua/StrudctureDefinition/Organization",
                                   "https://ehealth.gov.ua/StrudctureDefinition/Location"
                                 ],
                                 "security" => [%{"system" => "https://ehealth.gov.ua/CodeSystem/v4", "code" => "N", "display" => "normal" }],
                                 "tag" => [%{"system" => "https://ehealth.gov.ua/tag/", "code" => "N", "display" => "normal" }]
                             }
                          }
                        ]
                     })
  end

  get "/$export" do
    send(conn, 200, %{"resourceType" => "CapabilityStatement"})
  end

  post "/" do
    send(conn, 200, %{})
  end

  post "/$diff" do
    send(conn, 200, %{})
  end

  post "/$reindex" do
    send(conn, 200, %{})
  end

  post "/$export" do
    send(conn, 200, %{})
  end

  post "/$meta" do
    send(conn, 200, %{})
  end

  # GET

  get ":base/:type/:id" do
    send(conn, 200, %{"base" => base, "type" => type, "id" => id})
  end

  # POST

  post ":base/:qualifier" do
    send(conn, 200, %{"base" => base, "qualifier" => qualifier})
  end

  post ":base/:resource/:qualifier" do
    send(conn, 200, %{"base" => base, "resource" => resource, "qualifier" => qualifier})
  end

  post ":base/:compartment/:id/:qualifier" do
    send(conn, 200, %{"base" => base, "compartment" => compartment, "id" => id, "qualifier" => qualifier})
  end

  post ":base/:compartment/:id/:resource/:qualifier" do
    send(conn, 200, %{"base" => base, "compartment" => compartment, "resource" => resource,  "id" => id, "qualifier" => qualifier})
  end

  # PUT

  put ":base/:type/:id" do
    send(conn, 200, %{"base" => base, "type" => type, "id" => id})
  end

  # DELETE

  delete ":base/:type/:id" do
    send(conn, 200, %{"base" => base, "type" => type, "id" => id})
  end

end
