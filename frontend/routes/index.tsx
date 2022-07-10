/** @jsx h */
import { h } from "preact";
import { tw } from "@twind";
import { Handlers, PageProps } from "$fresh/server.ts";
import CreateTodo from "../islands/CreateTodo.tsx";

interface Todo {
  id: number;
  todo: string;
}

export const handler: Handlers<Todo[] | null> = {
  async GET(_: any, ctx: any) {
    try {
      const resp = await fetch(`http://localhost:8000/`);
      const data = await resp.json();
      const todo: Todo = await data.data;
      return ctx.render(todo);
    } catch (e) {
      return ctx.render(null);
    }
  },
};

export default function Home({ data }: PageProps<Todo[] | null>) {
  return (
    <div class={tw`max-w-screen-md`}>
      <h1 class={tw``}>First fresh website</h1>
      <CreateTodo />
      {data
        ? data.map((i: Todo) => (
          <div key={i.id}>
            {i.todo}
          </div>
        ))
        : (
          <div class={tw`text-lg italic font-medium`}>
            To do are not available
          </div>
        )}
    </div>
  );
}
