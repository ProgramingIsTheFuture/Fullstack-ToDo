open Cohttp
open Cohttp_lwt_unix
open Yojson.Safe

(* type 'a message = { *)
(*   message: string; *)
(*   data: 'a option [@yojson.option]; *)
(* } [@@deriving yojson];; *)

type todo = {
  id: int;
  todo: string;
} [@@deriving yojson];;

type message = {
  message: string;
  data: todo list option [@yojson.option];
} [@@deriving yojson];;

let todos = ref [{id = 0; todo = "Todo 1"}];;

(* This handler list all the todos *)
let base_get _conn _req _body =
  let data: todo list option = Some !todos in
  (* Converting the list of todos to json string *)
  let js = yojson_of_message 
    {message = "Success"; data = data} 
    |> to_string in

  (* sending the response *)
  Server.respond
    ~headers:(Header.init_with "Content-Type" "application/json") 
    ~status:`OK 
    ~body:(Cohttp_lwt.Body.of_string js) 
    ();;

(* This handler adds a new todo to the todos list *)
let create_todo _conn _req _body =
  (* Checks the body *)
  match Lwt.state (Cohttp_lwt.Body.to_string _body) with
  | Return (v) -> 
    (* Parses the string from body to json *)
    let new_t = Yojson.Safe.from_string v |> todo_of_yojson in
    todos := new_t:: !todos;
    (* Returns a response *)
    let js = yojson_of_message {message = "Created!"; data = None} |> to_string in
    Server.respond
      ~headers:(Header.init_with "Content-Type" "application/json") 
      ~status:`Created 
      ~body:(Cohttp_lwt.Body.of_string js) 
      ()
  | _ -> 
    (* Returns a bad response *)
    let js = yojson_of_message {message = "Body missing"; data = None} |> to_string in
    Server.respond 
      ~headers:(Header.init_with "Content-Type" "application/json") 
      ~status:`Bad_request 
      ~body:(Cohttp_lwt.Body.of_string js) 
      ();;

let not_found _conn _req _body = 
  let js = yojson_of_message {message = "Not Found"; data = None} |> to_string in
  Server.respond 
    ~headers:(Header.init_with "Content-Type" "application/json") 
    ~status:`Not_found 
    ~body:(Cohttp_lwt.Body.of_string js) 
    ();;
