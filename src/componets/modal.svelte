<script lang="ts">
  import { isOpen, typeDialog } from "../stores/stores";
  export let dialogTitle: string;
  export let app;

  type Task = {
    id: number | string;
    title: string;
    description: string;
  };
  export let taskObject: Task;
  import DialogContent from "./dialog.svelte";
</script>

{#if $isOpen && $typeDialog == "createTask"}
  <DialogContent {dialogTitle} {app}/>
{:else if $isOpen && $typeDialog == "updateTask"}
  <DialogContent {dialogTitle} {taskObject} {app} />
{/if}
