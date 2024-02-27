<template>
    <div v-if="!initialized">Loading...</div>
    <div v-else id="ledger_list">
        <Toolbar>
            <ToolbarButton
                :to="{ name: 'LedgerFormAdd' }"
                icon="plus"
                title="New ledger"
                v-if="isUserPermitted('create_ledger')"
            />
        </Toolbar>
        <div v-if="ledger_count > 0" class="page-section">
            <KohaTable
                ref="table"
                v-bind="tableOptions"
                @show="doShow"
                @edit="doEdit"
                @delete="doDelete"
            ></KohaTable>
        </div>
        <div v-else class="dialog message">
            There are no ledgers defined
        </div>
    </div>
</template>

<script>
import Toolbar from "../Toolbar.vue"
import ToolbarButton from "../ToolbarButton.vue"
import { inject, ref } from "vue"
import { APIClient } from "../../fetch/api-client.js"
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
            table,
            setConfirmationDialog,
            setMessage,
            isUserPermitted
        }
    },
    data() {
        const actionButtons = []
        if(this.isUserPermitted('edit_ledger')) { actionButtons.push("edit") }
        if(this.isUserPermitted('delete_ledger')) { actionButtons.push("delete") }
        return {
            ledger_count: 0,
            initialized: false,
            tableOptions: {
                columns: this.getTableColumns(),
                url: "/api/v1/contrib/acquire/ledgers",
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
            vm.getLedgerCount().then(() => (vm.initialized = true))
        })
    },
    methods: {
        async getLedgerCount() {
            const client = APIClient.acquisition
            await client.ledgers.count().then(
                count => {
                    this.ledger_count = count
                },
                error => {}
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
            return [
                {
                    title: __("Name"),
                    data: "name",
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
                    title: __("Description"),
                    data: "description",
                    searchable: true,
                    orderable: true,
                },
                {
                    title: __("Code"),
                    data: "description",
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
            ]
        },
    },
    components: { Toolbar, ToolbarButton, KohaTable },
}
</script>