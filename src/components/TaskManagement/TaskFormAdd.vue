<template>
    <div v-if="!initialized">Loading...</div>
    <div v-else id="task_add">
        <h2 v-if="task.task_id">
            {{ `Edit task ${task.task_id}` }}
        </h2>
        <h2 v-else>New task</h2>
        <div>
            <form @submit="onSubmit($event)">
                <fieldset class="rows">
                    <ol>
                        <li>
                            <label class="required" for="task_short_name"
                                >Short name:</label
                            >
                            <input
                                id="task_short_name"
                                v-model="task.short_name"
                                placeholder="Task short name"
                                required
                            />
                            <span class="required">Required</span>
                        </li>
                        <li>
                            <label for="task_module" class="required"
                                >Module:</label
                            >
                            <v-select
                                id="task_module"
                                v-model="task.module"
                                :reduce="av => av.code"
                                :options="modules"
                                label="name"
                            >
                                <template #search="{ attributes, events }">
                                    <input
                                        :required="!task.module"
                                        class="vs__search"
                                        v-bind="attributes"
                                        v-on="events"
                                    />
                                </template>
                            </v-select>
                            <span class="required">Required</span>
                        </li>
                        <li>
                            <label for="task_description" class="required"
                                >Description:
                            </label>
                            <textarea
                                id="task_description"
                                v-model="task.description"
                                placeholder="Description"
                                rows="10"
                                cols="50"
                                required
                            />
                            <span class="required">Required</span>
                        </li>
                        <li>
                            <label for="task_owner" class="required"
                                >Owner:</label
                            >
                            <v-select
                                id="task_owner"
                                v-model="task.owner"
                                :reduce="av => av.borrowernumber"
                                :options="getOwners"
                                label="displayName"
                            >
                                <template #search="{ attributes, events }">
                                    <input
                                        :required="!task.owner"
                                        class="vs__search"
                                        v-bind="attributes"
                                        v-on="events"
                                    />
                                </template>
                            </v-select>
                            <span class="required">Required</span>
                        </li>
                        <li>
                            <label for="task_status" class="required"
                                >Status:</label
                            >
                            <v-select
                                id="task_status"
                                v-model="task.status"
                                :reduce="av => av.value"
                                :options="statusOptions"
                                label="description"
                            >
                                <template #search="{ attributes, events }">
                                    <input
                                        :required="!task.status"
                                        class="vs__search"
                                        v-bind="attributes"
                                        v-on="events"
                                    />
                                </template>
                            </v-select>
                            <span class="required">Required</span>
                        </li>
                        <li>
                            <label for="end_date">End date:</label>
                            <flat-pickr
                                id="end_date"
                                v-model="task.end_date"
                                :config="fp_config"
                            />
                        </li>
                    </ol>
                </fieldset>
                <fieldset class="action">
                    <input type="submit" value="Submit" />
                    <router-link
                        :to="{ name: 'TaskList' }"
                        role="button"
                        class="cancel"
                        >Cancel</router-link
                    >
                </fieldset>
            </form>
        </div>
    </div>
</template>

<script>
import flatPickr from "vue-flatpickr-component"
import { inject } from "vue"
import { storeToRefs } from "pinia"
import { APIClient } from "../../fetch/api-client.js"
import { setMessage, setWarning } from "../../messages"

export default {
    setup() {
        const acquisitionsStore = inject("acquisitionsStore")
        const {
            library_groups,
            moduleList,
            getVisibleGroups,
            getOwners
        } = storeToRefs(acquisitionsStore)

        const { 
            isUserPermitted,
            filterGroupsBasedOnOwner,
            filterOwnersBasedOnGroup,
            resetOwnersAndVisibleGroups
        } = acquisitionsStore

        return {
            isUserPermitted,
            library_groups,
            moduleList,
            filterGroupsBasedOnOwner,
            filterOwnersBasedOnGroup,
            resetOwnersAndVisibleGroups,
            getVisibleGroups,
            getOwners
        }
    },
    data() {
        const modules = Object.keys(this.moduleList).map(key => {
            return this.moduleList[key]
        })
        return {
            initialized: false,
            fp_config: flatpickr_defaults,
            statusOptions: [
                { description: 'Assigned', value: 'assigned' },
                { description: 'Completed', value: 'complete' },
                { description: 'Cancelled', value: 'cancelled' },
                { description: 'On hold', value: 'on_hold' },
            ],
            task: {},
            modules
        }
    },
    beforeRouteEnter(to, from, next) {
        next(vm => {
            if (to.params.task_id) {
                vm.getTask(to.params.task_id)
            } else {
                vm.initialized = true
            }
        })
    },
    methods: {
        async getTask(task_id) {
            const client = APIClient.acquisition
            client.tasks.get(task_id).then(task => {
                this.task = task
                this.initialized = true
            })
        },
        onSubmit(e) {
            e.preventDefault()
            
            const task = JSON.parse(JSON.stringify(this.task))
            const task_id = task.task_id

            delete task.task_id

            if(task_id) {
                const acq_client = APIClient.acquisition
                acq_client.tasks
                    .update(task, task_id).then(
                        success => {
                            setMessage("Task updated")
                            this.$router.push({ name: "TaskList" })
                        },
                        error => {}
                    )
            } else {
                const acq_client = APIClient.acquisition
                acq_client.tasks
                    .create(task).then(
                        success => {
                            setMessage("Task created")
                            this.$router.push({ name: "TaskList" })
                        },
                        error => {}
                    )
            }
        }
    },
    unmounted() {
        this.resetOwnersAndVisibleGroups()
    },
    components: {
        flatPickr
    }
}
</script>

<style scoped>

</style>