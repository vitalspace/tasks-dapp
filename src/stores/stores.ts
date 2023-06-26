import { writable } from "svelte/store";

export let tasks = writable([]);
export let isOpen = writable(false);
export let typeDialog = writable("");