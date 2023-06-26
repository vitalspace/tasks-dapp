// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

contract Taks {
    struct taskBody {
        string title;
        string description;
        bool completed;
    }

    mapping(uint256 => taskBody) public tasks;
    uint256 public counterTask;

    event addedTask(
        uint256 id,
        string title,
        string description,
        bool completed
    );
    event updatedTask(uint256 id, string title, string newDescription);
    event completedTask(uint256 id);

    function addTask(string memory _title, string memory _descripcion) public {
        tasks[counterTask] = taskBody(_title, _descripcion, false);
        emit addedTask(counterTask, _title, _descripcion, false);
        counterTask++;
    }

    function viewTask(uint256 _id)
        public
        view
        returns (
            string memory title,
            string memory description,
            bool completed
        )
    {
        return (tasks[_id].title, tasks[_id].description, tasks[_id].completed);
    }

    function updateTask(
        uint256 _id,
        string memory _title,
        string memory _newDescription
    ) public {
        require(_id < counterTask, "The task does not exist.");
        tasks[_id].description = _newDescription;
        tasks[_id].title = _title;
        emit updatedTask(_id, _title, _newDescription);
    }

    function completeTask(uint256 _id) public {
        require(_id < counterTask, "The task does not exist.");
        bool currentStatus = tasks[_id].completed;
        tasks[_id].completed = !currentStatus;
        emit completedTask(_id);
    }
}
