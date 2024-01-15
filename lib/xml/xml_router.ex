defmodule HL7.XML.Router do
  use Routes.Base

  @database [%{"id" => 1, "title" => "Hello"}, %{"id" => 2, "title" => "world!"}]

  get "/" do
    send(conn, 200, @database)
  end

  post "/" do
    send(conn, 200, %{"id" => 3, "title" => "just been added"})
  end

  put "organization/:id" do
    send(conn, 200, %{"id" => id, "title" => "Just been updated"})
  end

  put "patient/:id" do
    send(conn, 200, %{"id" => id, "title" => "Just been updated"})
  end

  delete "/:id" do
    send(conn, 200, %{"id" => id, "title" => "Just been deleted"})
  end

end
