defmodule HL7.Endpoint do
      use Plug.Router
#     plug Plug.Logger
     plug :match
     plug :dispatch
     plug Plug.Parsers, parsers: [:json], json_decoder: Jason

        # Meta Service

      get "/"                               do HL7.Service.root(conn) end
     post "/"                               do HL7.Service.postRoot(conn) end
      get "/$meta"                          do HL7.Service.meta(conn) end
     post "/$meta"                          do HL7.Service.postMeta(conn) end
      get "/metadata"                       do HL7.Service.metadata(conn) end
      get "/$export"                        do HL7.Service.export(conn) end
     post "/$export"                        do HL7.Service.postExport(conn) end
     post "/$diff"                          do HL7.Service.postDiff(conn) end
     post "/$reindex"                       do HL7.Service.reindex(conn) end

        # Terminology

      get "/CodeSystem/$lookup"             do HL7.Service.get4(conn,[],"CodeSystem",[],"$lookup") end
      get "/CodeSystem/:id/$lookup"         do HL7.Service.get4(conn,[],"CodeSystem",id,"$lookup") end
      get "/CodeSystem/$validate-code"      do HL7.Service.get4(conn,[],"CodeSystem",[],"$validate-code") end
      get "/CodeSystem/:id/$validate-code"  do HL7.Service.get4(conn,[],"CodeSystem",id,"$validate-code") end
      get "/ValueSet/$expand"               do HL7.Service.get4(conn,[],"ValueSet",[],"$expand") end
      get "/ValueSet/:id/$expand"           do HL7.Service.get4(conn,[],"ValueSet",id,"$expand") end
      get "/ConceptMap/$closure"            do HL7.Service.get4(conn,[],"ConceptMap",[],"$closure") end
      get "/ConceptMap/:id/$closure"        do HL7.Service.get4(conn,[],"ConceptMap",id,"$closure") end
      get "/ConceptMap/$translate"          do HL7.Service.get4(conn,[],"ConceptMap",[],"$translate") end
      get "/ConceptMap/:id/$translate"      do HL7.Service.get4(conn,[],"ConceptMap",id,"$translate") end

        # Resource Instance Interactions

     post "/:type/$validate"                do HL7.Service.post4(conn,[],type,[],"$validate") end
      get "/:type/:id"                      do HL7.Service.get4(conn,[],type,id,"$base") end
      get "/:type/:id/_history"             do HL7.Service.get4(conn,[],type,id,"_history") end
      get "/:type/:id/_history/:vsn"        do HL7.Service.get4(conn,vsn,type,id,"_history") end
      put "/:type/:id"                      do HL7.Service.put4(conn,[],type,id,"$base") end
   delete "/:type/:id"                      do HL7.Service.delete4(conn,[],type,id,"$base") end

        # Whole Server Interactions

      get "/_history"                       do HL7.Service.history(conn) end
      get "/_diff"                          do HL7.Service.diff(conn) end
     post "/_search"                        do HL7.Service.post2(conn,[],"_search") end
     post "/:res/_search"                   do HL7.Service.post3(conn,[],res,"_search") end
     post "/:comp/:id/_search"              do HL7.Service.post4(conn,[],comp,id,"_search") end
     post "/:comp/:id/:res/_search"         do HL7.Service.post5(conn,[],comp,id,res,"_search") end

    match _ do send_resp(conn, 404,
          "Please refer to https://hl7.erp.uno manual" <>
          " for information about endpoints addresses.") end
end
