<template>
    <div v-if="!initialized">Loading...</div>
    <div v-else id="fiscal_yr_list">
        <Toolbar>
            <ToolbarButton
                :to="{ name: 'FiscalYearFormAdd' }"
                icon="plus"
                title="New fiscal year"
                v-if="isUserPermitted(['period_manage', 'planning_manage'])"
            />
        </Toolbar>
        <div v-if="fiscal_yr_count > 0" class="page-section">
            <KohaTable
                ref="table"
                v-bind="tableOptions"
                @show="doShow"
                @edit="doEdit"
                @delete="doDelete"
            ></KohaTable>
        </div>
        <div v-else class="dialog message">
            There are no fiscal years defined
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
        const actionButtons = this.isUserPermitted(['period_manage', 'planning_manage']) ? ["edit","delete"] : []
        return {
            fiscal_yr_count: 0,
            initialized: false,
            tableOptions: {
                columns: this.getTableColumns(),
                url: "/api/v1/contrib/acquire/fiscal_years",
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
            vm.getFiscalYearCount().then(() => (vm.initialized = true))
        })
    },
    methods: {
        async getFiscalYearCount() {
            const client = APIClient.acquisition
            await client.fiscal_years.count().then(
                count => {
                    this.fiscal_yr_count = count
                },
                error => {}
            )
        },
        doShow: function ({ fiscal_yr_id }, dt, event) {
            event.preventDefault()
            this.$router.push({ name: "FiscalYearShow", params: { fiscal_yr_id } })
        },
        doEdit: function ({ fiscal_yr_id }, dt, event) {
            this.$router.push({
                name: "FiscalYearFormEdit",
                params: { fiscal_yr_id },
            })
        },
        doDelete: function (fiscal_yr, dt, event) {
            this.setConfirmationDialog(
                {
                    title: "Are you sure you want to remove this fiscal year?",
                    message: fiscal_yr.name,
                    accept_label: "Yes, delete",
                    cancel_label: "No, do not delete",
                },
                () => {
                    const client = APIClient.acquisition
                    client.fiscal_years.delete(fiscal_yr.fiscal_yr_id).then(
                        success => {
                            this.setMessage(`Fiscal year deleted`, true)
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
                    title: __("Code"),
                    data: "code",
                    searchable: true,
                    orderable: true,
                    render: function (data, type, row, meta) {
                        return (
                            '<a href="/acquisitions/fund_management/fiscal_yr/' +
                            row.fiscal_yr_id +
                            '" class="show">' +
                            escape_str(`${row.code}`) +
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
                    title: __("Status"),
                    data: "status",
                    searchable: true,
                    orderable: true,
                    render: function (data, type, row, meta) {
                        return row.status ? "Active" : "Inactive"
                    },
                },
                {
                    title: __("Start date"),
                    data: "start_date",
                    searchable: true,
                    orderable: true,
                    render: function (data, type, row, meta) {
                        return $date(row.start_date)
                    },
                },
                {
                    title: __("End date"),
                    data: "end_date",
                    searchable: true,
                    orderable: true,
                    render: function (data, type, row, meta) {
                        return $date(row.end_date)
                    },
                },
            ]
        },
    },
    components: { Toolbar, ToolbarButton, KohaTable },
}
</script>
