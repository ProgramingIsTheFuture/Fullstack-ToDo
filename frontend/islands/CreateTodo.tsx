/** @jsx h */
import { h } from "preact";
import { useState } from "preact/hooks";
import { tw } from "@twind";

export default function CreateTodo() {
  const [message, setMessage] = useState("");
  const [todo, setTodo] = useState("");

  const handleSubmit = (e: Event) => {
    e.preventDefault();
    const submit = async () => {
      try {
        await fetch(`http://localhost:8000/create`, {
          method: "post",
          body: JSON.stringify({ id: 0, todo }),
        });
        setMessage("Success! :D");
      } catch (e) {
        setMessage("Failed! :(");
      }
    };
    submit();
    setTimeout(() => {
      setMessage("");
    }, 2000);
  };

  return (
    <div class={tw`p-4 max-w-screen-md`}>
      <div class={tw`text-lg italic font-medium`}>
        {message}
      </div>
      <form class={tw`flex flex-row`} onSubmit={handleSubmit}>
        <input
          class={tw`border m-2`}
          type={"text"}
          value={todo}
          onChange={(e: Event) => setTodo((e.target as HTMLInputElement).value)}
        />
        <button
          class={tw`m-2 bg-cyan-500 hover:bg-cyan-600`}
          type={"submit"}
        >
          <p class={tw`text-black-50`}>
            Criar!
          </p>
        </button>
      </form>
    </div>
  );
}
