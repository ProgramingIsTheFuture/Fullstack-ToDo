open Cohttp_lwt_unix
open Logs

let debug = true

let _ =
  set_level ~all:true (Some Info);

  (Server.make ~callback: 
     (Middleware.cors
        (if debug then Middleware.logger
             Router.router else Router.router))
     ())
  |> Server.create ~mode:(`TCP (`Port 8000)) 
;;

(*Lwt_main.run server;;*)

let _ =
  Opium.App.empty
  |> Opium.App.middleware Middleware.cors_opium
  |> Opium.App.middleware Middleware.logger_opium
  |> Opium.App.run_command
