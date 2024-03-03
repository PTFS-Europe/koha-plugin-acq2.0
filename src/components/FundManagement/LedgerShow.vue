<template>
    <div v-if="!initialized">Loading...</div>
    <div v-else id="ledgers_show">
        <Toolbar>
            <ToolbarLink
                :to="{ name: 'LedgerList' }"
                icon="xmark"
                title="Close"
            />
            <ToolbarLink
                :to="{ name: 'LedgerFormEdit', params: { ledger_id: ledger.ledger_id } }"
                icon="pencil"
                title="Edit"
                v-if="isUserPermitted('edit_ledger')"
            />
            <ToolbarButton
                icon="trash"
                title="Delete"
                @clicked="delete_ledger(ledger.ledger_id, ledger.name)"
                v-if="isUserPermitted('delete_ledger')"
            />
        </Toolbar>
        <h2>{{ ledger.name }}</h2>
        <div class="ledger_display">
            <DisplayDataFields 
                :data="ledger"
                homeRoute="LedgerList"
                dataType="ledger"
                :showClose="false"
            />
            <AccountingView 
                :data="ledger"
                :currencySymbol="currency.symbol"
            />
        </div>
    </div>
    <div v-if="initialized" id="funds">
        <div class="page-section">
            <h3>Funds</h3>
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
import { inject } from "vue"
import { APIClient } from "../../fetch/api-client.js"
import DisplayDataFields from "../DisplayDataFields.vue"
import KohaTable from "../KohaTable.vue"
import AccountingView from './AccountingView.vue'

export default {
    setup() {
        const { setConfirmationDialog, setMessage } = inject("mainStore")

        const acquisitionsStore = inject("acquisitionsStore")
        const { 
            isUserPermitted,
            getCurrency
        } = acquisitionsStore

        return {
            setConfirmationDialog,
            setMessage,
            isUserPermitted,
            getCurrency
        }
    },
    data() {
        return {
            ledger: {},
            initialized: false,
            tableOptions: {
                columns: this.getTableColumns(),
                url: this.tableUrl(),
                options: { embed: "koha_plugin_acquire_fund_allocations" },
                table_settings: null,
                add_filters: true,
                actions: {
                    0: ["show"],
                },
            },
            currency: null,
        }
    },
    beforeRouteEnter(to, from, next) {
        next(vm => {
            vm.ledger = vm.getLedger(to.params.ledger_id)
        })
    },
    methods: {
        async getLedger(ledger_id) {
            const client = APIClient.acquisition
            await client.ledgers.get(ledger_id, "fiscal_yr,koha_plugin_acquire_funds.koha_plugin_acquire_fund_allocations").then(
                ledger => {
                    this.ledger = ledger
                    this.currency = this.getCurrency(ledger.currency)
                    this.initialized = true
                },
                error => {}
            )
        },
        delete_ledger: function (ledger_id, ledger_code) {
            this.setConfirmationDialog(
                {
                    title: "Are you sure you want to remove this ledger?",
                    message: ledger_code,
                    accept_label: "Yes, delete",
                    cancel_label: "No, do not delete",
                },
                () => {
                    const client = APIClient.acquisition
                    client.ledgers.delete(ledger_id).then(
                        success => {
                            this.setMessage("Ledger deleted")
                            this.$router.push({ name: "LedgerList" })
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
                    title: __("Name"),
                    data: "name",
                    searchable: true,
                    orderable: true,
                    render: function (data, type, row, meta) {
                        return (
                            '<a href="/acquisitions/fund_management/fund/' +
                            row.fund_id +
                            '" class="show">' +
                            escape_str(`${row.name}`) +
                            "</a>"
                        )
                    },
                },
                {
                    title: __("Code"),
                    data: "code",
                    searchable: true,
                    orderable: true,
                },
                {
                    title: __("Status"),
                    data: "status",
                    searchable: true,
                    orderable: true,
                    render: function (data, type, row, meta) {
                        return row.status ? "Active" : "Inactive"
                    },
                },
                {
                    title: __("Fund value"),
                    data: "fund_total",
                    searchable: true,
                    orderable: true,
                    render: function (data, type, row, meta) {
                        const { symbol } = getCurrency(row.currency)
                        return symbol + row.fund_value
                    },
                },
            ]
        },
        tableUrl() {
            const id = this.$route.params.ledger_id
            let url = "/api/v1/contrib/acquire/funds?q="
            const query = {
                "me.ledger_id": id
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
#funds {
    margin-top: 1em;
}
.ledger_display {
    display: flex;
    gap: 1em;
}
</style>