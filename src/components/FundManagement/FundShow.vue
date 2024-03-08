<template>
    <div v-if="!initialized">Loading...</div>
    <div v-else id="funds_show">
        <Toolbar>
            <ToolbarLink
                :to="{ name: 'FundList' }"
                icon="xmark"
                title="Close"
            />
            <ToolbarLink
                :to="{ name: 'FundFormEdit', params: { fund_id: fund.fund_id } }"
                icon="pencil"
                title="Edit"
                v-if="isUserPermitted('edit_fund')"
            />
            <ToolbarButton
                icon="trash"
                title="Delete"
                @clicked="delete_fund(fund.fund_id, fund.name)"
                v-if="isUserPermitted('delete_fund')"
            />
            <ToolbarLink
                :to="{ name: 'FundAllocationFormAdd' }"
                icon="plus"
                title="New fund allocation"
                v-if="isUserPermitted('create_fund_allocation') && fund.status"
            />
            <ToolbarLink
                :to="{ name: 'TransferFunds', query: { fund_id: fund.fund_id } }"
                icon="arrow-right-arrow-left"
                title="Transfer funds"
                v-if="isUserPermitted('create_fund_allocation')"
            />
        </Toolbar>
        <h2>{{ fund.name }}</h2>
        <div class="fund_display">
            <DisplayDataFields 
                :data="fund"
                homeRoute="FundList"
                dataType="fund"
                :showClose="false"
            />
            <AccountingView 
                :data="fund"
                :currencySymbol="currency.symbol"
            />
        </div>
    </div>
    <div v-if="initialized" id="fund_allocations">
        <div class="page-section">
            <h3>Fund allocations</h3>
            <KohaTable
                ref="table"
                v-bind="tableOptions"
            ></KohaTable>
        </div>
    </div>
</template>

<script>
import Toolbar from "../Toolbar.vue"
import ToolbarButton from "../ToolbarButton.vue"
import ToolbarLink from "../ToolbarLink.vue"
import { inject, ref } from "vue"
import { APIClient } from "../../fetch/api-client.js"
import DisplayDataFields from "../DisplayDataFields.vue"
import KohaTable from "../KohaTable.vue"
import AccountingView from './AccountingView.vue'

export default {
    setup() {
        const { setConfirmationDialog, setMessage, setWarning } = inject("mainStore")

        const acquisitionsStore = inject("acquisitionsStore")
        const { 
            isUserPermitted,
            getCurrency
        } = acquisitionsStore

        const table = ref()

        return {
            setConfirmationDialog,
            setMessage,
            setWarning,
            isUserPermitted,
            getCurrency,
            table
        }
    },
    data() {
        return {
            fund: {},
            initialized: false,
            tableOptions: {
                columns: this.getTableColumns(),
                url: this.tableUrl(),
                table_settings: null,
                add_filters: true,
                actions: {
                    0: ["show"]
                },
            },
            currency: null,
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
            await client.funds.get(fund_id, "fiscal_yr,ledger,koha_plugin_acquire_fund_allocations").then(
                fund => {
                    this.fund = fund
                    this.currency = this.getCurrency(fund.currency)
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
        getTableColumns: function () {
            const getCurrency = this.getCurrency
            return [
                {
                    title: __("Date"),
                    data: "last_updated",
                    searchable: true,
                    orderable: true,
                    render: function (data, type, row, meta) {
                        return row.last_updated.substring(0,10)
                    },
                },
                {
                    title: __("Amount"),
                    data: "allocation_amount",
                    searchable: true,
                    orderable: true,
                    render: function (data, type, row, meta) {
                        const symbol = row.allocation_amount >= 0 ? "+" : ""
                        const colour = row.allocation_amount >= 0 ? "green" : "red"
                        return (
                            '<span style="color:' + colour + ';">' + symbol + row.allocation_amount + '</span>'
                        )
                    },
                },
                {
                    title: __("New fund total"),
                    data: "new_fund_value",
                    searchable: true,
                    orderable: true,
                    render: function (data, type, row, meta) {
                        const { symbol } = getCurrency(row.currency)
                        return symbol + row.new_fund_value
                    },
                },
                {
                    title: __("Reference"),
                    data: "reference",
                    searchable: true,
                    orderable: true,
                },
                {
                    title: __("Note"),
                    data: "note",
                    searchable: true,
                    orderable: true,
                }
            ]
        },
        showTransferWarning() {
            this.setWarning("This allocation was a transfer between funds and can't be edited or deleted.")
        },
        tableUrl() {
            const id = this.$route.params.fund_id
            let url = "/api/v1/contrib/acquire/fund_allocations?q="
            const query = {
                fund_id: id
            }
            return url + JSON.stringify(query)
        }
    },
    components: {
        DisplayDataFields,
        Toolbar,
        ToolbarButton,
        ToolbarLink,
        KohaTable,
        AccountingView
    },
}
</script>

<style scoped>
.action_links a {
    padding-left: 0.2em;
    font-size: 11px;
    cursor: pointer;
}
#fund_allocations {
    margin-top: 2em;
}
.fund_display {
    display: flex;
    gap: 1em;
}
</style>