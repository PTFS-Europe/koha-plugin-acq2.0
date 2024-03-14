<template>
    <div v-if="!initialized">Loading...</div>
    <div v-else id="fund_allocation_add">
        <h2 v-if="fund_allocation.fund_allocation_id">
            {{ `Edit fund allocation ${fund_allocation.fund_allocation_id}` }}
        </h2>
        <h2 v-else>New fund allocation</h2>
        <div>
            <form @submit="onSubmit($event)">
                <fieldset class="rows">
                    <ol>
                        <li>
                            <label for="fund_allocation_fund_id" class="required"
                                >Fund:</label
                            >
                            <InfiniteScrollSelect
                                id="fund_allocation_fund_id"
                                v-model="fund_allocation.fund_id"
                                :selectedData="selectedFund"
                                dataType="funds"
                                dataIdentifier="fund_id"
                                label="name"
                                apiClient="acquisition"
                                :required="true"
                            />
                            <span class="required">Required</span>
                        </li>
                        <li>
                            <label for="fund_allocation_amount" class="required"
                                >Allocation amount:</label
                            >
                            <input
                                id="fund_allocation_amount"
                                v-model="fund_allocation.allocation_amount"
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
                                v-model="fund_allocation.reference"
                                placeholder="Fund allocation reference"
                            />
                        </li>
                        <li>
                            <label for="fund_allocation_note"
                                >Note:
                            </label>
                            <textarea
                                id="fund_allocation_note"
                                v-model="fund_allocation.note"
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
                        :to="{ name: 'FundShow', params: { fund_id: selectedFund.fund_id } }"
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
import InfiniteScrollSelect from "../InfiniteScrollSelect.vue"

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
            fund_allocation: {
                fund_id: null,
                fiscal_yr_id: null,
                ledger_id: null,
                reference: '',
                note: '',
                currency: '',
                allocation_amount: null,
                visible_to: '',
            },
            funds: [],
            selectedFund: null
        }
    },
    beforeRouteEnter(to, from, next) {
        next(vm => {
            vm.getDataRequiredForPageLoad(to)
        })
    },
    methods: {
        async getDataRequiredForPageLoad(route) {
            const { params } = route
            this.getFund(params).then(() => {
                if(params.fund_allocation_id) {
                    this.getFundAllocation(params.fund_allocation_id)
                }
                this.initialized = true
            })
        },
        async getFundAllocation(fund_allocation_id) {
            const client = APIClient.acquisition
            await client.fund_allocations.get(fund_allocation_id).then(fund_allocation => {
                this.fund_allocation = fund_allocation
            })
        },
        async getFund(params) {
            const client = APIClient.acquisition
            await client.funds.get(params.fund_id).then(
                fund => {
                    this.selectedFund = fund
                    this.fund_allocation.fund_id = fund.fund_id
                    this.fund_allocation.ledger_id = fund.ledger_id
                    this.fund_allocation.fiscal_yr_id = fund.fiscal_yr_id
                    this.fund_allocation.currency = fund.currency
                    this.fund_allocation.owner = fund.owner
                    this.fund_allocation.visible_to = fund.visible_to
                },
                error => {}
            )
        },
        onSubmit(e) {
            e.preventDefault()
            
            if(!this.isUserPermitted('create_fund_allocation')) {
                setWarning('You do not have the required permissions to create fund allocations.')
                return
            }

            const fund_allocation = JSON.parse(JSON.stringify(this.fund_allocation))
            const fund_allocation_id = fund_allocation.fund_allocation_id

            delete fund_allocation.fund_allocation_id

            if(fund_allocation_id) {
                const acq_client = APIClient.acquisition
                acq_client.fund_allocations
                    .update(fund_allocation, fund_allocation_id).then(
                        success => {
                            setMessage("Fund allocation updated")
                            this.$router.push({ name: "FundShow", params: { fund_id: this.selectedFund.fund_id } })
                        },
                        error => {}
                    )
            } else {
                const acq_client = APIClient.acquisition
                acq_client.fund_allocations
                    .create(fund_allocation).then(
                        success => {
                            setMessage("Fund allocation created")
                            this.$router.push({ name: "FundShow", params: { fund_id: this.selectedFund.fund_id } })
                        },
                        error => {}
                    )
            }
        }
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