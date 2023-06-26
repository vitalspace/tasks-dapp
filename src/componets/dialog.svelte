<script lang="ts">
  import { isOpen, typeDialog } from "../stores/stores";
  import CloseIcon from "../icons/closeIcon.svelte";
  export let dialogTitle: string;
  export let app;

  type Task = {
    id: number | string;
    title: string;
    description: string;
  };

  export let taskObject: Task = {
    id: "",
    title: "",
    description: "",
  };

  const closeModal = () => {
    $isOpen = false;
  };

  const createTask = () => {
    const { title, description } = taskObject;
    app.createTask(title, description);
    closeModal();
  };

  const updateTask = () => {
    const { id, title, description } = taskObject;
    app.updateTask(id, title, description);
    closeModal();
  };
</script>

<div
  class="fixed top-0 left-0 h-full w-full flex justify-center items-center bg-gray-300 bg-opacity-50 z-10"
>
  <div class="w-full space-y-2 p-2 bg-white md:w-2/4 text-center rounded-md">
    <div class="flex justify-end">
      <button on:click={() => closeModal()}><CloseIcon /></button>
    </div>
    <div>
      <h2 class="text-pink-400 text-2xl py-4">
        {dialogTitle} {taskObject.id}
      </h2>
    </div>
    <div>
      <input
        bind:value={taskObject.title}
        class="w-full border-2 pl-2"
        type="text"
        name=""
        id=""
        placeholder="Title Task"
      />
    </div>
    <div>
      <textarea
        bind:value={taskObject.description}
        class="w-full border-2 pl-2"
        name=""
        id=""
        rows="5"
        placeholder="Content"
      />
    </div>
    {#if $isOpen && $typeDialog == "createTask"}
      <button
        class="bg-green-300 w-full py-2 text-white hover:bg-green-400 transition-all"
        on:click={() => createTask()}>Submit</button
      >
    {:else if $isOpen && $typeDialog == "updateTask"}
      <button
        class="bg-green-300 w-full py-2 text-white hover:bg-green-400 transition-all"
        on:click={() => updateTask()}>Submit</button
      >
    {/if}
  </div>
</div>
