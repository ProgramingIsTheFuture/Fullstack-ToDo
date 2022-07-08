open Cohttp_lwt_unix
open Logs

let server = 
  set_level ~all:true (Some Info);

  (Server.make ~callback: 
    (Middleware.logger 
      Router.router) ()) 
  |> Server.create ~mode:(`TCP (`Port 8000)) 
  ;;

Lwt_main.run server;;
