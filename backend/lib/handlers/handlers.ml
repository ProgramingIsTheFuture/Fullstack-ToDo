open Cohttp
open Cohttp_lwt_unix
open Yojson.Safe

(* type 'a message = { *)
(*   message: string; *)
(*   data: 'a option [@yojson.option]; *)
(* } [@@deriving yojson];; *)

type 'a message = {
  message: string;
  data: 'a option [@yojson.option];
} [@@deriving yojson];;
let str_toyojson a: Yojson.Safe.t = `String(a)

let todos = ref [str_toyojson "Hello"; str_toyojson "Todo2"];;

let base_get _conn _req _body =
  let data: Yojson.Safe.t list option = Some !todos in
  let js = yojson_of_message 
    (fun (a: Yojson.Safe.t list) ->
      `List(a)
      ) 
    {message = "Success"; data = data} 
    |> to_string in
  Server.respond
    ~headers:(Header.init_with "Content-Type" "application/json") 
    ~status:`OK 
    ~body:(Cohttp_lwt.Body.of_string js) 
    ();;

let not_found _conn _req _body = 
  let js = yojson_of_message (fun _ -> `Null) {message = "Not Found"; data = None} |> to_string in
  Server.respond 
    ~headers:(Header.init_with "Content-Type" "application/json") 
    ~status:`Not_found 
    ~body:(Cohttp_lwt.Body.of_string js) 
    ();;
