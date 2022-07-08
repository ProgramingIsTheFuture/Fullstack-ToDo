open Cohttp
open Cohttp_lwt_unix

(* ( body |> Cohttp_lwt.Body.to_string >|= fun body -> *)
(*   Printf.sprintf "Uri: %s\nMethod: %s\nHeaders\nHeaders: %s\nBody: %s" uri *)
(*     meth headers body ) *)
(* >>= fun body -> Server.respond_string ~status:`OK ~body ();; *)

let logger f _conn req body =
  f _conn req body |> ignore;
  let path = req |> Request.uri |> Uri.path in
  let meth = req |> Request.meth |> Code.string_of_method in
  let () = Lwt_fmt.printf "Method: %s PATH: %s\n" meth path |> ignore in
  Server.respond_string ~status:`OK ~body:("Hello") ();;


