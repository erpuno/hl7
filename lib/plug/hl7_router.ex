defmodule HL7.Router do
  use Plug.Router
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
  get  ":base/:type/:id"                 do HL7.Serivce.get3(conn,base,type,id) end
  post ":base/:qualifier"                do HL7.Serivce.get2(conn,base,qualifier) end
  post ":base/:resource/:qualifier"      do HL7.Serivce.post3(conn,base,resource,qualifier) end
  post ":base/:comp/:id/:qualifier"      do HL7.Serivce.post4(conn,base,comp,id,qualifier) end
  post ":base/:comp/:id/:res/:qualifier" do HL7.Serivce.post5(conn,base,comp,id,res,qualifier) end
  put  ":base/:type/:id"                 do HL7.Serivce.put3(conn,base,type,id) end
  delete ":base/:type/:id"               do HL7.Serivce.delete3(conn,base,type,id) end
end
