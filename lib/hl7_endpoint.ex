defmodule HL7.Endpoint do
  use Plug.Router
  plug Plug.Logger
  plug :match
  plug :dispatch
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  get  "/"          do HL7.Service.root(conn) end
  get  "/metadata"  do HL7.Service.metadata(conn) end
  get  "/_history"  do HL7.Service.history(conn) end
  get  "/_diff"     do HL7.Service.diff(conn) end
  get  "/$meta"     do HL7.Service.meta(conn) end
  get  "/$export"   do HL7.Service.export(conn) end
  post "/"          do HL7.Service.postRoot(conn) end
  post "/$diff"     do HL7.Service.postDiff(conn) end
  post "/$reindex"  do HL7.Service.reindex(conn) end
  post "/$export"   do HL7.Service.postExport(conn) end
  post "/$meta"     do HL7.Service.postMeta(conn) end
  get  "/:type/:id"              do HL7.Service.get3(conn,"",type,id) end
  put  "/:type/:id"              do HL7.Service.put3(conn,"",type,id) end
  delete ":type/:id"             do HL7.Service.delete3(conn,"",type,id) end
  post "/_search"                do HL7.Service.post2(conn,"","_search") end
  post "/:res/_search"           do HL7.Service.post3(conn,"",res,"_search") end
  post "/:comp/:id/_search"      do HL7.Service.post4(conn,"",comp,id,"_search") end
  post "/:comp/:id/:res/_search" do HL7.Service.post5(conn,"",comp,id,res,"_search") end
  match _ do send_resp(conn, 404, "Not found!") end
end
