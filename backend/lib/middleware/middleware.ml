open Cohttp.Response
open Cohttp
open Cohttp_lwt_unix
open Lwt

(* Logs all the endpoints *)
let logger f _conn req body =
  (* Handling the request *)
  let r: (Cohttp.Response.t * Cohttp_lwt.Body.t) Lwt.t = f _conn req body in
  (* Getting the status code *)
  let status = match state r with
  | Return (v) ->
      let (ss, _) = v in
      Code.code_of_status ss.status
  | _ -> 0 in
  (* Getting the path  *)
  let path = req |> Request.uri |> Uri.path in
  (* Getting the method  *)
  let meth = req |> Request.meth |> Code.string_of_method in
  (* Printing the information about this request *)
  let () = Lwt_fmt.printf "Status: %d Method: %s PATH: %s\n" status meth path |> ignore in
  (* returning the response *)
  r;;

(* Allow all origins to access this API *)
let cors f _conn req body =
  let r: (Cohttp.Response.t * Cohttp_lwt.Body.t) Lwt.t = f _conn req body in

  match state r with
  | Return (v) ->
    let (resp, body) = v in

    let headers = resp.headers in
    let n_headers = Cohttp.Header.add headers "Access-Control-Allow-Origin" "*" in

    Lwt.return (
      {encoding = resp.encoding; 
       headers = n_headers; 
       version = resp.version; 
       status = resp.status; 
       flush = resp.flush 
      }, 
      body)
  | _ -> r;;
