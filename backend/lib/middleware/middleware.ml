open Cohttp
open Cohttp_lwt_unix
open Lwt

(* ( body |> Cohttp_lwt.Body.to_string >|= fun body -> *)
(*   Printf.sprintf "Uri: %s\nMethod: %s\nHeaders\nHeaders: %s\nBody: %s" uri *)
(*     meth headers body ) *)
(* >>= fun body -> Server.respond_string ~status:`OK ~body ();; *)

let logger f _conn req body =
  let r: (Cohttp.Response.t * Cohttp_lwt.Body.t) Lwt.t = f _conn req body in
  let status = match state r with
  | Return (v) ->
      let (ss, _) = v in
      Code.code_of_status ss.status
  | _ -> 0 in
  let path = req |> Request.uri |> Uri.path in
  let meth = req |> Request.meth |> Code.string_of_method in
  let () = Lwt_fmt.printf "Status: %d Method: %s PATH: %s\n" status meth path |> ignore in
  r;;


