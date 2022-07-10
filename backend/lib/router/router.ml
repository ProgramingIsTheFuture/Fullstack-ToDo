open Cohttp
open Cohttp_lwt_unix


let router _conn req body = 
  let path = req |> Request.uri |> Uri.path in
  let meth = req |> Request.meth |> Code.string_of_method in
  match (path, meth) with
  | ("/", "GET") -> Handlers.base_get _conn req body
  | ("/create", "POST") -> Handlers.create_todo _conn req body
  | _ -> 
    Handlers.not_found _conn req body;;

