<template>
    <div v-if="!initialized">Loading...</div>
    <div v-else id="ledger_add">
        <h2 v-if="ledger.ledger_id">
            {{ `Edit ledger ${ledger.ledger_id}` }}
        </h2>
        <h2 v-else>New ledger</h2>
        <div>
            <form @submit="onSubmit($event)">
                <fieldset class="rows">
                    <ol>
                        <li>
                            <label class="required" for="ledger_name"
                                >Name:</label
                            >
                            <input
                                id="ledger_name"
                                v-model="ledger.name"
                                placeholder="Ledger name"
                                required
                            />
                            <span class="required">Required</span>
                        </li>
                        <li>
                            <label for="ledger_description"
                                >Description:
                            </label>
                            <textarea
                                id="ledger_description"
                                v-model="ledger.description"
                                placeholder="Description"
                                rows="10"
                                cols="50"
                            />
                        </li>
                        <li>
                            <label class="required" for="ledger_code"
                                >Code:</label
                            >
                            <input
                                id="ledger_code"
                                v-model="ledger.code"
                                placeholder="Ledger code"
                                required
                            />
                            <span class="required">Required</span>
                        </li>
                        <li>
                            <label for="ledger_fiscal_period_id" class="required"
                                >Fiscal period:</label
                            >
                            <InfiniteScrollSelect
                                id="ledger_fiscal_period_id"
                                v-model="ledger.fiscal_period_id"
                                :selectedData="fiscal_period"
                                dataType="fiscalPeriods"
                                dataIdentifier="fiscal_period_id"
                                label="code"
                                apiClient="acquisition"
                                :required="true"
                                @update:modelValue="filterGroupsBySelectedFiscalPeriod($event)"
                            />
                            <span class="required">Required</span>
                        </li>
                        <li>
                            <label for="ledger_status" class="required"
                                >Status:</label
                            >
                            <v-select
                                id="ledger_status"
                                v-model="ledger.status"
                                :reduce="av => av.value"
                                :options="statusOptions"
                                label="description"
                            >
                                <template #search="{ attributes, events }">
                                    <input
                                        :required="!statusOptions.map(opt => opt.value).includes(ledger.status)"
                                        class="vs__search"
                                        v-bind="attributes"
                                        v-on="events"
                                    />
                                </template>
                            </v-select>
                            <span class="required">Required</span>
                        </li>
                        <li>
                            <label for="ledger_external_id"
                                >External ID:</label
                            >
                            <input
                                id="ledger_external_id"
                                v-model="ledger.external_id"
                                placeholder="External id for use with third party accounting software"
                            />
                        </li>
                        <li>
                            <label for="ledger_currency" class="required"
                                >Currency:</label
                            >
                            <v-select
                                id="ledger_currency"
                                v-model="ledger.currency"
                                :reduce="av => av.currency"
                                :options="currencies"
                                label="currency"
                            >
                                <template #search="{ attributes, events }">
                                    <input
                                        :required="!ledger.currency"
                                        class="vs__search"
                                        v-bind="attributes"
                                        v-on="events"
                                    />
                                </template>
                            </v-select>
                            <span class="required">Required</span>
                        </li>
                        <li>
                            <label for="ledger_owner" class="required"
                                >Owner:</label
                            >
                            <v-select
                                id="ledger_owner"
                                v-model="ledger.owner_id"
                                :reduce="av => av.borrowernumber"
                                :options="getOwners"
                                @update:modelValue="filterGroupsBasedOnOwner($event, ledger, fiscal_period_groups)"
                                label="displayName"
                            >
                                <template #search="{ attributes, events }">
                                    <input
                                        :required="!ledger.owner_id"
                                        class="vs__search"
                                        v-bind="attributes"
                                        v-on="events"
                                    />
                                </template>
                            </v-select>
                            <span class="required">Required</span>
                        </li>
                        <li>
                            <label for="ledger_visible_to" class="required"
                                >Visible to:</label
                            >
                            <v-select
                                id="ledger_visible_to"
                                v-model="ledger.visible_to"
                                :reduce="av => av.id"
                                :options="getVisibleGroups"
                                label="title"
                                @update:modelValue="filterOwnersBasedOnGroup($event, ledger, fiscal_period_groups)"
                                multiple
                                :disabled="fiscal_period_groups.length === 0"
                            >
                                <template #search="{ attributes, events }">
                                    <input
                                        :required="!ledger.visible_to"
                                        class="vs__search"
                                        v-bind="attributes"
                                        v-on="events"
                                    />
                                </template>
                            </v-select>
                            <span class="required">Required</span>
                        </li>
                        <li>
                            <label for="ledger_over_spend_allowed" class="required"
                                >Overspend allowed?:</label
                            >
                            <v-select
                                id="ledger_over_spend_allowed"
                                v-model="ledger.over_spend_allowed"
                                :reduce="av => av.value"
                                :options="allowedOptions"
                                label="description"
                            >
                                <template #search="{ attributes, events }">
                                    <input
                                        :required="ledger.over_spend_allowed === null"
                                        class="vs__search"
                                        v-bind="attributes"
                                        v-on="events"
                                    />
                                </template>
                            </v-select>
                            <span class="required">Required</span>
                        </li>
                        <li>
                            <label for="ledger_over_encumbrance_allowed" class="required"
                                >Overencumbrance allowed?:</label
                            >
                            <v-select
                                id="ledger_over_encumbrance_allowed"
                                v-model="ledger.over_encumbrance_allowed"
                                :reduce="av => av.value"
                                :options="allowedOptions"
                                label="description"
                            >
                                <template #search="{ attributes, events }">
                                    <input
                                        :required="ledger.over_encumbrance_allowed === null"
                                        class="vs__search"
                                        v-bind="attributes"
                                        v-on="events"
                                    />
                                </template>
                            </v-select>
                            <span class="required">Required</span>
                        </li>
                        <li>
                            <label for="ledger_oe_warning_percent"
                                >Overencumbrance warning percentage:</label
                            >
                            <input
                                id="ledger_oe_warning_percent"
                                v-model="ledger.oe_warning_percent"
                                placeholder="Percentage that triggers a warning"
                                type="number"
                                min="0"
                                max="100"
                                step=".01"
                            />
                        </li>
                        <li>
                            <label for="ledger_oe_limit_amount"
                                >Overencumbrance limit amount:</label
                            >
                            <input
                                id="ledger_oe_limit_amount"
                                v-model="ledger.oe_limit_amount"
                                placeholder="The amount at which a block is triggered"
                                type="number"
                                step=".01"
                            />
                        </li>
                        <li>
                            <label for="ledger_os_warning_sum"
                                >Overspend warning sum:</label
                            >
                            <input
                                id="ledger_os_warning_sum"
                                v-model="ledger.os_warning_sum"
                                placeholder="The amount at which a warning is triggered"
                                type="number"
                                step=".01"
                            />
                        </li>
                        <li>
                            <label for="ledger_os_limit_sum"
                                >Overspend limit sum:</label
                            >
                            <input
                                id="ledger_os_limit_sum"
                                v-model="ledger.os_limit_sum"
                                placeholder="The amount at which a block is triggered"
                                type="number"
                                step=".01"
                            />
                        </li>
                    </ol>
                </fieldset>
                <fieldset class="action">
                    <input type="submit" value="Submit" />
                    <router-link
                        :to="{ name: 'LedgerList' }"
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
import { inject } from "vue"
import { storeToRefs } from "pinia"
import { APIClient } from "../../fetch/api-client.js"
import { setMessage, setWarning } from "../../messages"
import InfiniteScrollSelect from "../InfiniteScrollSelect.vue"

export default {
    setup() {
        const acquisitionsStore = inject("acquisitionsStore")
        const {
            libraryGroups,
            getVisibleGroups,
            getOwners
        } = storeToRefs(acquisitionsStore)

        const { 
            isUserPermitted,
            filterGroupsBasedOnOwner,
            filterOwnersBasedOnGroup,
            resetOwnersAndVisibleGroups,
            formatLibraryGroupIds
        } = acquisitionsStore

        return {
            isUserPermitted,
            libraryGroups,
            filterGroupsBasedOnOwner,
            filterOwnersBasedOnGroup,
            formatLibraryGroupIds,
            resetOwnersAndVisibleGroups,
            getVisibleGroups,
            getOwners
        }
    },
    data() {
        return {
            initialized: false,
            statusOptions: [
                { description: 'Active', value: 1 },
                { description: 'Inactive', value: 0 },
            ],
            allowedOptions: [
                { description: 'Allowed', value: 1 },
                { description: 'Not allowed', value: 0 },
            ],
            ledger: {
                fiscal_period_id: null,
                name: '',
                description: '',
                code: '',
                external_id: '',
                currency: null,
                status: null,
                owner_id: null,
                visible_to: [],
                over_spend_allowed: null,
                over_encumbrance_allowed: null,
                oe_warning_percent: null,
                oe_limit_amount: null,
                os_warning_sum: null,
                os_limit_sum: null,
            },
            fiscal_period: null,
            currencies: [],
            fiscal_period_groups: [],
        }
    },
    beforeRouteEnter(to, from, next) {
        next(vm => {
            vm.getDataRequiredForPageLoad(to.params.ledger_id)
        })
    },
    methods: {
    async getDataRequiredForPageLoad(ledger_id) {
            this.getCurrencies().then(() => {
                if(ledger_id) {
                    this.getLedger(ledger_id).then(() => {
                        this.getFiscalPeriod(this.ledger.fiscal_period_id)
                    })
                } else {
                    this.initialized = true
                }
            })
        },
        async getLedger(ledger_id) {
            const client = APIClient.acquisition
            await client.ledgers.get(ledger_id).then(ledger => {
                this.ledger = ledger
                this.ledger.oe_warning_percent = ledger.oe_warning_percent * 100
                this.ledger.visible_to = this.formatLibraryGroupIds(ledger.visible_to)
                this.filterGroupsBySelectedFiscalPeriod(ledger.fiscal_period_id)
            })
        },
        async getFiscalPeriod(fiscal_period_id) {
            const client = APIClient.acquisition
            await client.fiscalPeriods.get(fiscal_period_id).then(
                fiscal_period => {
                    this.fiscal_period = fiscal_period
                    this.initialized = true
                },
                error => {}
            )
        },
        async getCurrencies() {
            const client = APIClient.acquisition
            await client.currencies.getAll().then(
                currencies => {
                    this.currencies = currencies
                },
                error => {}
            )
        },
        filterGroupsBySelectedFiscalPeriod(e) {
            if(!e) {
                this.fiscal_period_groups = []
                this.ledger.visible_to = []
                return
            }
            this.getFiscalPeriod(e).then(() => {
                const applicableGroups = this.formatLibraryGroupIds(this.fiscal_period.visible_to)
                this.fiscal_period_groups = applicableGroups
                this.resetOwnersAndVisibleGroups(applicableGroups)
            })
            if(e !== this.ledger.fiscal_period_id) {
                this.ledger.visible_to = []
            }
        },
        onSubmit(e) {
            e.preventDefault()
            
            if(!this.isUserPermitted('createLedger')) {
                setWarning('You do not have the required permissions to create ledgers.')
                return
            }

            const ledger = JSON.parse(JSON.stringify(this.ledger))
            const ledger_id = ledger.ledger_id

            const visibility = ledger.visible_to.join("|")
            ledger.visible_to = visibility
            const oe_warning_percent = ledger.oe_warning_percent
            ledger.oe_warning_percent = oe_warning_percent / 100

            delete ledger.ledger_id

            if(ledger_id) {
                const acq_client = APIClient.acquisition
                acq_client.ledgers
                    .update(ledger, ledger_id).then(
                        success => {
                            setMessage("Ledger updated")
                            this.$router.push({ name: "LedgerList" })
                        },
                        error => {}
                    )
            } else {
                const acq_client = APIClient.acquisition
                acq_client.ledgers
                    .create(ledger).then(
                        success => {
                            setMessage("Ledger created")
                            this.$router.push({ name: "LedgerList" })
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
        InfiniteScrollSelect
    }
}
</script>

<style scoped>
fieldset.rows label {
    width: 15em;
}
</style>