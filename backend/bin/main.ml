open Cohttp_lwt_unix
open Logs

let debug = true

let server = 
  set_level ~all:true (Some Info);

  (Server.make ~callback: 
    (Middleware.cors
      (if debug then Middleware.logger 
        Router.router else Router.router))
    ()) 
  |> Server.create ~mode:(`TCP (`Port 8000)) 
  ;;

Lwt_main.run server;;
