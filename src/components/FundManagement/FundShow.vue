<template>
    <div v-if="!initialized">Loading...</div>
    <div v-else id="funds_show">
        <Toolbar>
            <ToolbarButton
                :to="{ name: 'FundFormEdit', params: { fund_id: fund.fund_id } }"
                icon="pencil"
                title="Edit"
                v-if="isUserPermitted('edit_fund')"
            />
            <ToolbarButton
                to="#"
                icon="trash"
                title="Delete"
                @clicked="delete_fund(fund.fund_id, fund.name)"
                v-if="isUserPermitted('delete_fund')"
            />
            <ToolbarButton
                :to="{ name: 'FundAllocationFormAdd' }"
                icon="plus"
                title="New fund allocation"
                v-if="isUserPermitted('create_fund_allocation')"
            />
        </Toolbar>
        <h2>{{ "Fund " + fund.fund_id }}</h2>
        <DisplayDataFields 
            :data="fund"
            homeRoute="FundList"
            dataType="fund"
            :showClose="false"
        />
    </div>
    <div v-if="initialized" id="fund_allocations">
        <div class="page-section">
            <h3>Fund allocations</h3>
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
import Toolbar from "../Toolbar.vue"
import ToolbarButton from "../ToolbarButton.vue"
import { inject, ref } from "vue"
import { APIClient } from "../../fetch/api-client.js"
import DisplayDataFields from "../DisplayDataFields.vue"
import KohaTable from "../KohaTable.vue"

export default {
    setup() {
        const { setConfirmationDialog, setMessage } = inject("mainStore")

        const acquisitionsStore = inject("acquisitionsStore")
        const { 
            isUserPermitted,
        } = acquisitionsStore

        const table = ref()

        return {
            setConfirmationDialog,
            setMessage,
            isUserPermitted,
            table
        }
    },
    data() {
        const actionButtons = []
        if(this.isUserPermitted('edit_fund_allocation')) { actionButtons.push("edit") }
        if(this.isUserPermitted('delete_fund_allocation')) { actionButtons.push("delete") }
        return {
            fund: {},
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
        doShow: function ({ fund_allocation_id }, dt, event) {
            event.preventDefault()
            this.$router.push({ name: "FundAllocationShow", params: { fund_allocation_id } })
        },
        doEdit: function ({ fund_allocation_id }, dt, event) {
            this.$router.push({
                name: "FundAllocationFormEdit",
                params: { fund_allocation_id, fund_id: this.fund.fund_id },
            })
        },
        doDelete: function (fund_allocation, dt, event) {
            this.setConfirmationDialog(
                {
                    title: "Are you sure you want to remove this fund allocation?",
                    message: fund_allocation.reference,
                    accept_label: "Yes, delete",
                    cancel_label: "No, do not delete",
                },
                () => {
                    const client = APIClient.acquisition
                    client.tasks.delete(fund_allocation.fund_allocation_id).then(
                        success => {
                            this.setMessage(`Fund allocation deleted`, true)
                            dt.draw()
                        },
                        error => {}
                    )
                }
            )
        },
        getTableColumns: function () {
            return [
                {
                    title: __("Allocation count"),
                    data: "fund_allocation_id",
                    searchable: true,
                    orderable: true,
                    render: function (data, type, row, meta) {
                        return (
                            `Allocation ${row.allocation_index}`
                        )
                    },
                },
                {
                    title: __("Amount"),
                    data: "allocation_amount",
                    searchable: true,
                    orderable: true,
                    render: function (data, type, row, meta) {
                        const symbol = row.allocation_amount >= 0 ? "+" : "-"
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
                },
                {
                    title: __("Note"),
                    data: "note",
                    searchable: true,
                    orderable: true,
                }
            ]
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
#fund_allocations {
    margin-top: 2em;
}
</style>