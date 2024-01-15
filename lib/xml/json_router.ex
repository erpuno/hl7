defmodule HL7.JSON.Router do
  use Routes.Base

  @database [%{"id" => 1, "title" => "Hello"}, %{"id" => 2, "title" => "world!"}]

  get "/" do
    send(conn, 200, @database)
  end

  post "/" do
    send(conn, 200, %{"id" => 3, "title" => "just been added"})
  end

  put "/:id" do
    send(conn, 200, %{"id" => id, "title" => "Just been updated"})
  end

  delete "/:id" do
    send(conn, 200, %{"id" => id, "title" => "Just been deleted"})
  end

end
