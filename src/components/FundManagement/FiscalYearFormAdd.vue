<template>
    <div v-if="!initialized">Loading...</div>
    <div v-else id="fiscal_year_add">
        <h2 v-if="fiscal_yr.fiscal_yr_id">
            {{ `Edit fiscal year ${fiscal_yr.fiscal_yr_id}` }}
        </h2>
        <h2 v-else>New fiscal year</h2>
        <div>
            <form @submit="onSubmit($event)">
                <fieldset class="rows">
                    <ol>
                        <li>
                            <label class="required" for="fiscal_yr_code"
                                >Code:</label
                            >
                            <input
                                id="fiscal_yr_code"
                                v-model="fiscal_yr.code"
                                placeholder="Fiscal year code"
                                required
                            />
                            <span class="required">Required</span>
                        </li>
                        <li>
                            <label for="fiscal_yr_description" class="required"
                                >Description:
                            </label>
                            <textarea
                                id="fiscal_yr_description"
                                v-model="fiscal_yr.description"
                                placeholder="Description"
                                rows="10"
                                cols="50"
                                required
                            />
                            <span class="required">Required</span>
                        </li>
                        <li>
                            <label for="fiscal_yr_status" class="required"
                                >Status:</label
                            >
                            <v-select
                                id="fiscal_yr_status"
                                v-model="fiscal_yr.status"
                                :reduce="av => av.value"
                                :options="statusOptions"
                                label="description"
                            >
                                <template #search="{ attributes, events }">
                                    <input
                                        :required="!fiscal_yr.status"
                                        class="vs__search"
                                        v-bind="attributes"
                                        v-on="events"
                                    />
                                </template>
                            </v-select>
                            <span class="required">Required</span>
                        </li>
                        <li>
                            <label for="start_date"
                                >Start date:</label
                            >
                            <flat-pickr
                                id="start_date"
                                v-model="fiscal_yr.start_date"
                                :config="fp_config"
                                data-date_to="end_date"
                            />
                        </li>
                        <li>
                            <label for="end_date">End date:</label>
                            <flat-pickr
                                id="end_date"
                                v-model="fiscal_yr.end_date"
                                :config="fp_config"
                            />
                        </li>
                        <li>
                            <label for="fiscal_yr_owner" class="required"
                                >Owner:</label
                            >
                            <v-select
                                id="fiscal_yr_owner"
                                v-model="fiscal_yr.owner"
                                :reduce="av => av.borrowernumber"
                                :options="getUsersFilteredByPermission(null, true)"
                                label="displayName"
                            >
                                <template #search="{ attributes, events }">
                                    <input
                                        :required="!fiscal_yr.owner"
                                        class="vs__search"
                                        v-bind="attributes"
                                        v-on="events"
                                    />
                                </template>
                            </v-select>
                            <span class="required">Required</span>
                        </li>
                        <li>
                            <label for="fiscal_yr_visible_to" class="required"
                                >Visible to:</label
                            >
                            <v-select
                                id="fiscal_yr_visible_to"
                                v-model="fiscal_yr.visible_to"
                                :reduce="av => av.id"
                                :options="getLibGroupsForUser()"
                                label="title"
                                multiple
                            >
                                <template #search="{ attributes, events }">
                                    <input
                                        :required="!fiscal_yr.visible_to"
                                        class="vs__search"
                                        v-bind="attributes"
                                        v-on="events"
                                    />
                                </template>
                            </v-select>
                            <span class="required">Required</span>
                        </li>
                    </ol>
                </fieldset>
                <fieldset class="action">
                    <input type="submit" value="Submit" />
                    <router-link
                        :to="{ name: 'FiscalYearList' }"
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
            user,
            settings,
            library_groups,
            permittedUsers
        } = storeToRefs(acquisitionsStore)

        const { 
            getUsersFilteredByPermission,
            isUserPermitted,
            getLibGroupsForUser
        } = acquisitionsStore

        return {
            getUsersFilteredByPermission,
            isUserPermitted,
            getLibGroupsForUser,
            library_groups
        }
    },
    data() {
        return {
            initialized: false,
            fp_config: flatpickr_defaults,
            statusOptions: [
                { description: 'Active', value: 1 },
                { description: 'Inactive', value: 0 },
            ],
            fiscal_yr: {
                fiscal_yr_id: null,
                description: "",
                code: "",
                status: null,
                owner: null,
                visible_to: [],
                start_date: undefined,
                end_date: undefined,
            },
        }
    },
    beforeRouteEnter(to, from, next) {
        next(vm => {
            if (to.params.fiscal_yr_id) {
                vm.getFiscalYear(to.params.fiscal_yr_id)
            } else {
                vm.initialized = true
            }
        })
    },
    methods: {
        async getFiscalYear(fiscal_yr_id) {
            const client = APIClient.acquisition
            client.fiscal_years.get(fiscal_yr_id).then(fiscal_yr => {
                this.fiscal_yr = fiscal_yr
                const groups = fiscal_yr.visible_to.includes("|") ? fiscal_yr.visible_to.split("|") : [ fiscal_yr.visible_to ]
                const groupIds = groups.map(group => {
                    return parseInt(group)
                })
                this.fiscal_yr.visible_to = groupIds
                this.initialized = true
            })
        },
        onSubmit(e) {
            e.preventDefault()
            
            if(!this.isUserPermitted('create_fiscal_year')) {
                setWarning('You do not have the required permissions to create fiscal years.')
                return
            }

            const fiscal_yr = JSON.parse(JSON.stringify(this.fiscal_yr))
            const fiscal_yr_id = fiscal_yr.fiscal_yr_id

            const visibility = fiscal_yr.visible_to.join("|")
            fiscal_yr.visible_to = visibility

            delete fiscal_yr.fiscal_yr_id

            if(fiscal_yr_id) {
                const acq_client = APIClient.acquisition
                acq_client.fiscal_years
                    .update(fiscal_yr, fiscal_yr_id).then(
                        success => {
                            setMessage("Fiscal year updated")
                            this.$router.push({ name: "FiscalYearList" })
                        },
                        error => {}
                    )
            } else {
                const acq_client = APIClient.acquisition
                acq_client.fiscal_years
                    .create(fiscal_yr).then(
                        success => {
                            setMessage("Fiscal year created")
                            this.$router.push({ name: "FiscalYearList" })
                        },
                        error => {}
                    )
            }
        }
    },
    components: {
        flatPickr
    }
}
</script>

<style scoped>

</style>