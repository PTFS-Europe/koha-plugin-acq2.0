<template>
    <div v-if="!initialized">Loading...</div>
    <div v-else id="task_list">
        <Toolbar>
            <ToolbarLink
                :to="{ name: 'TaskFormAdd' }"
                icon="plus"
                title="New task"
            />
        </Toolbar>
        <fieldset v-if="task_count > 0" class="filters">
            <input
                @click="filterTable('owner')"
                id="filter_table"
                type="button"
                :value="showUserCreatedTasksButtonText"
            />
            <input
                @click="filterTable('status')"
                id="filter_table"
                type="button"
                :value="showCompletedTasksButtonText"
            />
        </fieldset>
        <div v-if="task_count > 0" class="page-section">
            <h2>{{ tableName }}</h2>
            <KohaTable
                ref="table"
                v-bind="tableOptions"
                @show="doShow"
                @edit="doEdit"
                @delete="doDelete"
            ></KohaTable>
        </div>
        <div v-else class="dialog message">
            There are no tasks outstanding
        </div>
    </div>
</template>

<script>
import Toolbar from "../Toolbar.vue"
import ToolbarLink from "../ToolbarLink.vue"
import { inject, ref } from "vue"
import { storeToRefs } from "pinia"
import { APIClient } from "../../fetch/api-client.js"
import KohaTable from "../KohaTable.vue"

export default {
    setup() {
        const { setConfirmationDialog, setMessage } = inject("mainStore")
        const acquisitionsStore = inject("acquisitionsStore")
        const { 
            isUserPermitted,
        } = acquisitionsStore
        const { 
            moduleList,
            user
        } = storeToRefs(acquisitionsStore)

        const table = ref()

        return {
            table,
            setConfirmationDialog,
            setMessage,
            isUserPermitted,
            moduleList,
            user,
        }
    },
    data() {
        const actionButtons = []
        if(this.isUserPermitted('edit_task')) { actionButtons.push("edit") }
        if(this.isUserPermitted('delete_task')) { actionButtons.push("delete") }
        return {
            task_count: 0,
            initialized: false,
            tableOptions: {
                columns: this.getTableColumns(),
                url: this.tableUrl(),
                table_settings: null,
                add_filters: true,
                actions: {
                    0: ["show"],
                    "-1": actionButtons,
                },
            },
            showCreatedTasks: false,
            showCompletedTasks: false,
            tableName: "Your tasks",
            showUserCreatedTasksButtonText: "Show tasks created by you",
            showCompletedTasksButtonText: "Show completed tasks"
        }
    },
    beforeRouteEnter(to, from, next) {
        next(vm => {
            vm.getTaskCount().then(() => (vm.initialized = true))
        })
    },
    methods: {
        async getTaskCount() {
            const client = APIClient.acquisition
            await client.tasks.count().then(
                count => {
                    this.task_count = count
                },
                error => {}
            )
        },
        tableUrl() {
            let url = "/api/v1/contrib/acquire/tasks?q="
            const param = this.user.logged_in_user.borrowernumber
            const query = {
                owner: param,
                status: ['assigned', 'on_hold', 'cancelled']
            }
            if(this.showCreatedTasks) {
                delete query.owner
                query.created_by = param
            }
            if(this.showCompletedTasks) {
                query.status.push('complete')
            }
            const queryObject = JSON.stringify(query)
            return url + queryObject
        },
        filterTable(button) {
            if(button === 'owner') {
                if(this.showCreatedTasks) {
                    this.showCreatedTasks = false
                    this.tableName = "Your tasks"
                    this.showUserCreatedTasksButtonText = "Show tasks created by you"
                    this.$refs.table.redraw(this.tableUrl())
                } else {
                    this.showCreatedTasks = true
                    this.tableName = "Tasks created by you"
                    this.showUserCreatedTasksButtonText = "Show tasks assigned to you"
                    this.$refs.table.redraw(this.tableUrl())
                }
            }
            if(button === 'status') {
                if(this.showCompletedTasks) {
                    this.showCompletedTasks = false
                    this.showCompletedTasksButtonText = "Show completed tasks"
                    this.$refs.table.redraw(this.tableUrl())
                } else {
                    this.showCompletedTasks = true
                    this.showCompletedTasksButtonText = "Hide completed tasks"
                    this.$refs.table.redraw(this.tableUrl())
                }
            }
        },
        doShow: function ({ task_id }, dt, event) {
            event.preventDefault()
            this.$router.push({ name: "TaskShow", params: { task_id } })
        },
        doEdit: function ({ task_id }, dt, event) {
            this.$router.push({
                name: "TaskFormEdit",
                params: { task_id },
            })
        },
        doDelete: function (task, dt, event) {
            this.setConfirmationDialog(
                {
                    title: "Are you sure you want to remove this task?",
                    message: task.name,
                    accept_label: "Yes, delete",
                    cancel_label: "No, do not delete",
                },
                () => {
                    const client = APIClient.acquisition
                    client.tasks.delete(task.task_id).then(
                        success => {
                            this.setMessage(`Task deleted`, true)
                            dt.draw()
                        },
                        error => {}
                    )
                }
            )
        },
        getTableColumns: function () {
            const moduleList = this.moduleList

            return [
                {
                    title: __("Name"),
                    data: "short_name",
                    searchable: true,
                    orderable: true,
                    render: function (data, type, row, meta) {
                        return (
                            '<a href="/acquisitions/tasks/task/' +
                            row.task_id +
                            '" class="show">' +
                            escape_str(`${row.short_name}`) +
                            "</a>"
                        )
                    },
                },
                {
                    title: __("Module"),
                    data: "module",
                    searchable: true,
                    orderable: true,
                    render: function (data, type, row, meta) {
                        return moduleList[row.module].name
                    },
                },
                {
                    title: __("Status"),
                    data: "status",
                    searchable: true,
                    orderable: true,
                    render: function (data, type, row, meta) {
                        return  row.status.charAt(0).toUpperCase() + row.status.slice(1) 
                    },
                },
                {
                    title: __("Created on"),
                    data: "created_on",
                    searchable: true,
                    orderable: true,
                    render: function (data, type, row, meta) {
                        return $date(row.created_on)
                    },
                },
                {
                    title: __("Target date"),
                    data: "end_date",
                    searchable: true,
                    orderable: true,
                    render: function (data, type, row, meta) {
                        return $date(row.end_date)
                    },
                },
            ]
        },
    },
    components: { Toolbar, ToolbarLink, KohaTable },
}
</script>

<style scoped>
.filters > label[for="by_mine_filter"],
.filters > input[type="checkbox"],
.filters > input[type="button"] {
    margin-left: 1rem;
}
</style>
