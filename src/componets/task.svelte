<script lang="ts">
  import EditIcon from "../icons/editIcon.svelte";
  export let app;
  export let id;
  export let title: string;
  export let description: string;
  export let completed: boolean;
  export let updateTask;
</script>

<div class="my-2 mr-2 rounded-md border-2 bg-slate-200 p-2 text-justify">
  <div class="flex justify-between">
    <h2 class="text-lg font-bold uppercase text-pink-400">{title}</h2>
    <button
      on:click={updateTask}
      class="
    rounded-full bg-pink-300 px-2 text-white transition-all hover:bg-pink-400 scale-90 hover:scale-100
    "
    >
      <EditIcon />
    </button>
  </div>
  <p class="text-gray-500">{description}</p>

  <div class="flex items-center">
    <label class="relative inline-flex items-center cursor-pointer">
      {#if completed}
        <input
          type="checkbox"
          value=""
          class="sr-only peer"
          checked
          on:click={() => app.completeTask(id)}
        />
      {:else}
        <input
          type="checkbox"
          value=""
          class="sr-only peer"
          on:click={() => app.completeTask(id)}
        />
      {/if}
      <div
        class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600"
      />
      {#if completed}
        <span
          class="ml-3 text-sm font-medium text-green-900 dark:text-green-400"
          >Completed</span
        >
      {:else}
        <span class="ml-3 text-sm font-medium text-gray-900 dark:text-gray-400"
          >Completed</span
        >
      {/if}
    </label>
  </div>

  <!-- <button
    class="rounded-sm bg-green-300 px-2 text-white transition-all hover:bg-green-400"
    >{completed}</button
  > -->
</div>
