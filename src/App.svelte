<script lang="ts">
  import AddIcon from "./icons/addIcon.svelte";
  import MetamaskIcon from "./componets/metamaskIcon.svelte";
  import Task from "./componets/task.svelte";
  import Contract from "./contracts/contract.json";
  import Modal from "./componets/modal.svelte";
  import { isOpen, typeDialog, tasks } from "./stores/stores";

  let dialogTile: string = "";

  type Task = {
    id: string | number;
    title: string;
    description: string;
  };
  let taskObject: Task;

  const openDialog = () => {
    dialogTile = "Create new task";
    $isOpen = true;
    $typeDialog = "createTask";
  };

  const openDialogUpdate = ({ id, title, description }) => {
    dialogTile = "Update task: ";
    $isOpen = true;
    $typeDialog = "updateTask";
    taskObject = {
      id,
      title,
      description,
    };
  };

  let isLoggedIn: boolean = false;

  class App {
    protected web3: any;
    protected contractAddress: string =
      "0x75a0E3e61Cee4cBe655cd5de481501c97bF72F6F";
    protected contract: any;
    protected tasksArr: [] = [];

    constructor() {
      // defaultEvmStores.setProvider();
      this.existsWallet();
    }

    private async existsWallet() {
      //@ts-ignore
      if (!window.ethereum) {
        alert("Please install metamask");
      } else {
        this.isLoggedIn();
      }
    }

    private async isLoggedIn() {
      //@ts-ignore
      const account = await window.ethereum.request({
        method: "eth_accounts",
      });

      if (account.length > 0) {
        isLoggedIn = true;
        this.loadWeb3();
      }
    }

    login = async () => {
      //@ts-ignore
      if (window.ethereum) {
        //@ts-ignore
        window.ethereum
          .request({
            method: "eth_requestAccounts",
          })
          .then((res) => {
            if (res) this.isLoggedIn();
          })
          .catch((err) => {
            if (err.code === 4001) alert("User rejected the request.");
          });
      }
      this.existsWallet();
    };

    private async loadWeb3() {
      //@ts-ignore
      if (window.ethereum) {
        //@ts-ignore
        this.web3 = await new Web3(window.ethereum);
        await this.loadContract();
        await this.allTasks();
      }
    }

    private async loadContract() {
      this.contract = await new this.web3.eth.Contract(
        Contract,
        this.contractAddress
      );
    }

    allTasks = async () => {
      console.log("ejecutandome")

      this.tasksArr = [];
      const totalTask = Number(
        await this.contract.methods.counterTask().call()
      );
      for (let index = 0; index < totalTask; index++) {
        //@ts-ignore
        this.tasksArr.push(await this.contract.methods.viewTask(index).call());
      }
      tasks.update((e) => (e = this.tasksArr));
    };

    createTask = async (title: string, description: string) => {
      // @ts-ignore
      const account = await window.ethereum.request({
        method: "eth_accounts",
      });
      this.contract.methods
        .addTask(title, description)
        .send({
          from: account[0],
          gas: 300000,
        })
        .on("transactionHash", function (hash) {
          console.log("Approving", hash);
        })
        .on("receipt", async (receipt) => {
          if (receipt) {
            await this.allTasks();
          }
        })
        .catch((revertReason) => {
          console.log(revertReason);
        });
    };

    updateTask = async (id: number, title: string, description: string) => {
      //@ts-ignore
      const account = await window.ethereum.request({
        method: "eth_accounts",
      });

      this.contract.methods
        .updateTask(id, title, description)
        .send({
          from: account[0],
          gas: 300000,
        })
        .on("transactionHash", (hash) => {
          console.log("Approving", hash);
        })
        .on("receipt", async (receipt) => {
          if (receipt) await this.allTasks();
        })
        .catch((err: Error) => {
          console.log(err);
        });
    };

    completeTask = async (id: number) => {
      //@ts-ignore
      const account = await window.ethereum.request({
        method: "eth_accounts",
      });

      this.contract.methods
        .completeTask(id)
        .send({
          from: account[0],
          gas: 300000,
        })
        .on("receipt", async (receipt) => {
          if (receipt) await this.allTasks();
        })
        .catch(async (err: Error) => {
          if (err) {
            alert(err);
            await this.allTasks()
          }

          // console.log(err);
        });
    };
  }

  const app = new App();
</script>

<div class="flex h-screen items-center justify-center bg-gray-800">
  <div
    class="bg-slate-00 w-96 rounded-md border-2 border-green-400 p-2 text-center shadow-lg shadow-slate-700"
  >
    <div class="my-7">
      <h1 class="text-3xl text-cyan-300 underline">Tasks Dapp</h1>
    </div>

    {#if isLoggedIn}
      <div class="my-2 flex items-center justify-center space-x-4">
        <button
          on:click={() => openDialog()}
          class="rounded-md bg-pink-300 transition-all hover:bg-pink-400"
          title="Add task"
        >
          <AddIcon />
        </button>
      </div>

      <div>
        <Modal dialogTitle={dialogTile} {taskObject} {app} />
      </div>
      <div class="h-80 overflow overflow-y-scroll">
        {#each $tasks.slice().reverse() as task, index}
          <Task
            {app}
            id={$tasks.length - 1 - index}
            title={task.title}
            description={task.description}
            updateTask={() =>
              openDialogUpdate({
                id: $tasks.length - 1 - index,
                title: task.title,
                description: task.description,
              })}
            completed={task.completed}
          />
        {/each}
      </div>
    {:else}
      <div class="my-6 bg-slate-200 py-6 rounded-md">
        <p class="text-gray-600">Please login with metamask</p>
      </div>
      <button
        on:click={() => app.login()}
        class="bg-orange-400 hover:bg-orange-500 text-white rounded-md w-full flex justify-center"
        ><MetamaskIcon /></button
      >
    {/if}
  </div>
</div>
