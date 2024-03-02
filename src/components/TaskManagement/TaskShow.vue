<template>
    <div v-if="!initialized">Loading...</div>
    <div v-else id="tasks_show">
        <Toolbar>
            <ToolbarLink
                :to="{ name: 'TaskList' }"
                icon="xmark"
                title="Close"
            />
            <ToolbarLink
                :to="{ name: 'TaskFormEdit', params: { task_id: task.task_id } }"
                icon="pencil"
                title="Edit"
            />
            <ToolbarButton
                icon="trash"
                title="Delete"
                @clicked="delete_task(task.task_id, task.short_name)"
            />
        </Toolbar>
        <h2>{{ "Task " + task.task_id }}</h2>
        <DisplayDataFields 
            :data="task"
            homeRoute="TaskList"
            dataType="task"
            :showClose="false"
        />
    </div>
</template>

<script>
import { inject } from "vue"
import { APIClient } from "../../fetch/api-client.js"
import DisplayDataFields from "../DisplayDataFields.vue"
import Toolbar from "../Toolbar.vue"
import ToolbarButton from "../ToolbarButton.vue"
import ToolbarLink from "../ToolbarLink.vue"

export default {
    setup() {
        const { setConfirmationDialog, setMessage } = inject("mainStore")

        return {
            setConfirmationDialog,
            setMessage,
        }
    },
    data() {
        return {
            task: {},
            initialized: false,
        }
    },
    beforeRouteEnter(to, from, next) {
        next(vm => {
            vm.task = vm.getTask(to.params.task_id)
        })
    },
    methods: {
        async getTask(task_id) {
            const client = APIClient.acquisition
            await client.tasks.get(task_id).then(
                task => {
                    this.task = task
                    this.initialized = true
                },
                error => {}
            )
        },
        delete_task: function (task_id, task_name) {
            this.setConfirmationDialog(
                {
                    title: "Are you sure you want to remove this task?",
                    message: task_name,
                    accept_label: "Yes, delete",
                    cancel_label: "No, do not delete",
                },
                () => {
                    const client = APIClient.acquisition
                    client.tasks.delete(task_id).then(
                        success => {
                            this.setMessage("Task deleted")
                            this.$router.push({ name: "TaskList" })
                        },
                        error => {}
                    )
                }
            )
        },
    },
    components: {
        DisplayDataFields,
        Toolbar,
        ToolbarButton,
        ToolbarLink,
    },
}
</script>
<style scoped>
.action_links a {
    padding-left: 0.2em;
    font-size: 11px;
    cursor: pointer;
}
#task_documents ul {
    padding-left: 0px;
}
</style>