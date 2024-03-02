<template>
    <div v-if="!initialized">Loading...</div>
    <div v-else id="fiscal_yrs_show">
        <Toolbar>
            <ToolbarLink
                :to="{ name: 'FiscalYearList' }"
                icon="xmark"
                title="Close"
            />
            <ToolbarLink
                :to="{ name: 'FiscalYearFormEdit', params: { fiscal_yr_id: fiscal_yr.fiscal_yr_id } }"
                icon="pencil"
                title="Edit"
                v-if="isUserPermitted('edit_fiscal_year')"
            />
            <ToolbarButton
                icon="trash"
                title="Delete"
                @clicked="delete_fiscal_yr(fiscal_yr.fiscal_yr_id, fiscal_yr.code)"
                v-if="isUserPermitted('delete_fiscal_year')"
            />
        </Toolbar>
        <h2>{{ "Fiscal year " + fiscal_yr.fiscal_yr_id }}</h2>
        <DisplayDataFields 
            :data="fiscal_yr"
            homeRoute="FiscalYearList"
            dataType="fiscal_year"
            :showClose="false"
        />
    </div>
    <div v-if="initialized" id="ledgers">
        <div class="page-section">
            <h3>Ledgers</h3>
            <KohaTable
                ref="table"
                v-bind="tableOptions"
                @show="doShow"
                @edit="doEdit"
                @delete="doDelete"
            ></KohaTable>
        </div>
    </div>
</template>

<script>
import { inject, ref } from "vue"
import { APIClient } from "../../fetch/api-client.js"
import DisplayDataFields from "../DisplayDataFields.vue"
import Toolbar from "../Toolbar.vue"
import ToolbarButton from "../ToolbarButton.vue"
import ToolbarLink from "../ToolbarLink.vue"
import KohaTable from "../KohaTable.vue"

export default {
    setup() {
        const { setConfirmationDialog, setMessage } = inject("mainStore")

        const acquisitionsStore = inject("acquisitionsStore")
        const { 
            isUserPermitted,
            getCurrency
        } = acquisitionsStore

        const table = ref()

        return {
            setConfirmationDialog,
            setMessage,
            isUserPermitted,
            getCurrency,
            table
        }
    },
    data() {
        const actionButtons = []
        if(this.isUserPermitted('edit_ledger')) { actionButtons.push("edit") }
        if(this.isUserPermitted('delete_ledger')) { actionButtons.push("delete") }
        return {
            fiscal_yr: {},
            initialized: false,
            tableOptions: {
                columns: this.getTableColumns(),
                url: this.tableUrl(),
                options: { embed: "koha_plugin_acquire_funds" },
                table_settings: null,
                add_filters: true,
                actions: {
                    0: ["show"],
                    "-1": actionButtons,
                },
            },
        }
    },
    beforeRouteEnter(to, from, next) {
        next(vm => {
            vm.fiscal_yr = vm.getFiscalYear(to.params.fiscal_yr_id)
        })
    },
    methods: {
        async getFiscalYear(fiscal_yr_id) {
            const client = APIClient.acquisition
            await client.fiscal_years.get(fiscal_yr_id).then(
                fiscal_yr => {
                    this.fiscal_yr = fiscal_yr
                    this.initialized = true
                },
                error => {}
            )
        },
        delete_fiscal_yr: function (fiscal_yr_id, fiscal_yr_code) {
            this.setConfirmationDialog(
                {
                    title: "Are you sure you want to remove this fiscal year?",
                    message: fiscal_yr_code,
                    accept_label: "Yes, delete",
                    cancel_label: "No, do not delete",
                },
                () => {
                    const client = APIClient.acquisition
                    client.fiscal_years.delete(fiscal_yr_id).then(
                        success => {
                            this.setMessage("Fiscal year deleted")
                            this.$router.push({ name: "FiscalYearList" })
                        },
                        error => {}
                    )
                }
            )
        },
        doShow: function ({ ledger_id }, dt, event) {
            event.preventDefault()
            this.$router.push({ name: "LedgerShow", params: { ledger_id } })
        },
        doEdit: function ({ ledger_id }, dt, event) {
            this.$router.push({
                name: "LedgerFormEdit",
                params: { ledger_id },
            })
        },
        doDelete: function (ledger, dt, event) {
            this.setConfirmationDialog(
                {
                    title: "Are you sure you want to remove this ledger?",
                    message: ledger.name,
                    accept_label: "Yes, delete",
                    cancel_label: "No, do not delete",
                },
                () => {
                    const client = APIClient.acquisition
                    client.ledgers.delete(ledger.ledger_id).then(
                        success => {
                            this.setMessage(`Ledger deleted`, true)
                            dt.draw()
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
                    data: "name:ledger_id",
                    searchable: true,
                    orderable: true,
                    render: function (data, type, row, meta) {
                        return (
                            '<a href="/acquisitions/fund_management/ledger/' +
                            row.ledger_id +
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
                    title: __("Fund count"),
                    data: "status",
                    searchable: true,
                    orderable: true,
                    render: function (data, type, row, meta) {
                        return row.koha_plugin_acquire_funds.length
                    },
                },
                {
                    title: __("Ledger value"),
                    searchable: true,
                    orderable: true,
                    render: function (data, type, row, meta) {
                        const sum = row.koha_plugin_acquire_funds.reduce((acc, curr) => acc + curr.fund_value, 0)
                        const { symbol } = getCurrency(row.currency)
                        return symbol + sum
                    },
                },
            ]
        },
        tableUrl() {
            const id = this.$route.params.fiscal_yr_id
            let url = "/api/v1/contrib/acquire/ledgers?q="
            const query = {
                "me.fiscal_yr_id": id
            }
            return url + JSON.stringify(query)
        }
    },
    components: {
        DisplayDataFields,
        Toolbar,
        ToolbarButton,
        ToolbarLink,
        KohaTable
    },
}
</script>
<style scoped>
.action_links a {
    padding-left: 0.2em;
    font-size: 11px;
    cursor: pointer;
}
#fiscal_yr_documents ul {
    padding-left: 0px;
}
</style>