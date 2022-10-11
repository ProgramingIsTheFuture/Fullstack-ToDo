
(*let debug = true*)

(*let _ =
  let open Cohttp_lwt_unix Logs in

   set_level ~all:true (Some Info);

   (Server.make ~callback:
     (Middleware.cors
        (if debug then Middleware.logger
             Router.router else Router.router))
     ())
   |> Server.create ~mode:(`TCP (`Port 8000))
   ;;*)

(*Lwt_main.run server;;*)

(* let _ = *)
(*   Opium.App.empty *)
(*   |> Opium.App.not_found Handlers.not_found_opium *)
(*   |> Opium.App.get "/" Handlers.base_get_opium *)
(*   |> Opium.App.post "/create" Handlers.create_todo_opium *)
(*   |> Opium.App.middleware Middleware.cors_opium *)
(*   |> Opium.App.middleware Middleware.logger_opium *)
(*   |> Opium.App.port 8000 *)
(*   |> Opium.App.run_command *)

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/" (fun _ ->
        Dream.json "{\"message\": \"Hello World\"}"
      )
  ]
