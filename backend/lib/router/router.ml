open Cohttp
open Cohttp_lwt_unix

let base_get _conn _ _ =
  Server.respond_string ~status:`OK ~body:("Hello") ();;

let router _conn req body = 
  let path = req |> Request.uri |> Uri.path in
  let meth = req |> Request.meth |> Code.string_of_method in
  match (path, meth) with
  | ("/", "GET") -> base_get _conn req body
  | _ -> 
    Server.respond_not_found ();;

