<template>
    <div v-if="!initialized">Loading...</div>
    <div v-else id="fund_allocation_add">
        <h2>Transfer between funds</h2>
        <div>
            <form @submit="onSubmit($event)">
                <fieldset class="rows">
                    <ol>
                        <li>
                            <label for="fund_allocation_fund_id" class="required"
                                >Fund to transfer to:</label
                            >
                            <v-select
                                id="fund_allocation_fund_id"
                                v-model="fund_transfer.fund_id_to"
                                :reduce="av => av.fund_id"
                                :options="funds"
                                label="name"
                            >
                                <template #search="{ attributes, events }">
                                    <input
                                        :required="!fund_transfer.fund_id_to"
                                        class="vs__search"
                                        v-bind="attributes"
                                        v-on="events"
                                    />
                                </template>
                            </v-select>
                            <span class="required">Required</span>
                        </li>
                        <li>
                            <label for="fund_allocation_amount" class="required"
                                >Allocation amount:</label
                            >
                            <input
                                id="fund_allocation_amount"
                                v-model="fund_transfer.transfer_amount"
                                type="number"
                                step=".01"
                            />
                            <span class="required">Required</span>
                        </li>
                        <li>
                            <label for="fund_allocation_reference"
                                >Reference:</label
                            >
                            <input
                                id="fund_allocation_reference"
                                v-model="fund_transfer.reference"
                                placeholder="Fund transfer reference"
                            />
                        </li>
                        <li>
                            <label for="fund_allocation_note"
                                >Note:
                            </label>
                            <textarea
                                id="fund_allocation_note"
                                v-model="fund_transfer.note"
                                placeholder="Notes"
                                rows="10"
                                cols="50"
                            />
                        </li>
                    </ol>
                </fieldset>
                <fieldset class="action">
                    <input type="submit" value="Submit" />
                    <router-link
                        :to="{ name: 'FundShow', params: { fund_id: fund_transfer.fund_id_from } }"
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
import { APIClient } from "../../fetch/api-client.js"
import { setMessage, setWarning } from "../../messages"

export default {
    setup() {
        const acquisitionsStore = inject("acquisitionsStore")
        const { 
            isUserPermitted,
        } = acquisitionsStore

        return {
            isUserPermitted,
        }
    },
    data() {
        return {
            initialized: false,
            fund_transfer: {
                fund_id_from: null,
                fund_id_to: null,
                reference: '',
                note: '',
                transfer_amount: null,
            },
            funds: [],
        }
    },
    beforeRouteEnter(to, from, next) {
        next(vm => {
            vm.getFunds(to)
        })
    },
    methods: {
        async getFunds(route) {
            const { query } = route
            const client = APIClient.acquisition
            await client.funds.getAll(null, {}).then(
                funds => {
                    const query_id = parseInt(query.fund_id)
                    this.funds = funds.filter(fund => (fund.fund_id !== query_id && fund.status))
                    this.fund_transfer.fund_id_from = query_id
                    this.initialized = true
                },
                error => {}
            )
        },
        onSubmit(e) {
            e.preventDefault()
            
            if(!this.isUserPermitted('create_fund_allocation')) {
                setWarning('You do not have the required permissions to transfer funds.')
                return
            }

            const fund_transfer = JSON.parse(JSON.stringify(this.fund_transfer))

            const acq_client = APIClient.acquisition
            acq_client.fund_allocations
                .transfer(fund_transfer).then(
                    success => {
                        setMessage("Funds successfully transferred")
                        this.$router.push({ name: "FundShow", params: { fund_id: this.$route.query.fund_id } })
                    },
                    error => {}
                )
        }
    }
}
</script>

<style scoped>
fieldset.rows label {
    width: 15em;
}
</style>