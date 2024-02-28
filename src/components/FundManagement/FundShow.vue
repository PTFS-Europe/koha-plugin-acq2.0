<template>
    <div v-if="!initialized">Loading...</div>
    <div v-else id="funds_show">
        <h2>
            {{ "Fund " + fund.fund_id }}
            <span class="action_links">
                <router-link
                    :to="{
                        name: 'FundFormEdit',
                        params: { fund_id: fund.fund_id },
                    }"
                    title="Edit"
                    ><i class="fa fa-pencil"></i
                ></router-link>
                <a @click="delete_fund(fund.fund_id, fund.code)"
                    ><i class="fa fa-trash"></i
                ></a>
            </span>
        </h2>
        <DisplayDataFields 
            :data="fund"
            homeRoute="FundList"
            dataType="fund"
        />
    </div>
</template>

<script>
import { inject } from "vue"
import { APIClient } from "../../fetch/api-client.js"
import DisplayDataFields from "../DisplayDataFields.vue"

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
            fund: {},
            initialized: false,
        }
    },
    beforeRouteEnter(to, from, next) {
        next(vm => {
            vm.fund = vm.getFund(to.params.fund_id)
        })
    },
    methods: {
        async getFund(fund_id) {
            const client = APIClient.acquisition
            await client.funds.get(fund_id, "fiscal_yr,ledger").then(
                fund => {
                    this.fund = fund
                    this.initialized = true
                },
                error => {}
            )
        },
        delete_fund: function (fund_id, fund_code) {
            this.setConfirmationDialog(
                {
                    title: "Are you sure you want to remove this fund?",
                    message: fund_code,
                    accept_label: "Yes, delete",
                    cancel_label: "No, do not delete",
                },
                () => {
                    const client = APIClient.acquisition
                    client.funds.delete(fund_id).then(
                        success => {
                            this.setMessage("Fund deleted")
                            this.$router.push({ name: "FundList" })
                        },
                        error => {}
                    )
                }
            )
        },
    },
    components: {
        DisplayDataFields
    },
}
</script>

<style scoped>
.action_links a {
    padding-left: 0.2em;
    font-size: 11px;
    cursor: pointer;
}
</style>