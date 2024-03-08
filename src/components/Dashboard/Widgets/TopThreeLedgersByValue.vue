<template>
    <div v-if="initialized" class="page-section">
        <h1>Top three ledgers by value</h1>
        <KohaTable
            ref="ledgersTable"
            v-bind="tableOptionsLedgers"
        ></KohaTable>
    </div>
</template>

<script>
import KohaTable from "../../KohaTable.vue"
import { ref } from "vue"

export default {
    setup() {
        const ledgersTable = ref()

        return {
            ledgersTable,
        }
    },
    data() {
        return {
            tableOptionsLedgers: {
                columns: this.getTableColumns('ledger'),
                url: "/api/v1/contrib/acquire/ledgers",
                options: { 
                    dom: '<"top pager"<"table_entries">>tr<"bottom pager">',
                    pageLength: 3,
                    order: [
                        [1, 'desc']
                    ]
                },
                table_settings: null,
                add_filters: true,
            },
            ledgers: [],
            initialized: true
        }
    },
    methods: {
        getTableColumns: function (dataType) {
            return [
                {
                    title: __("Name"),
                    data: `name`,
                    searchable: true,
                    orderable: true,
                    render: function (data, type, row, meta) {
                        const key = `${dataType}_id`
                        return (
                            `<a href="/acquisitions/fund_management/${dataType}/` +
                            row[key]+
                            '" class="show">' +
                            escape_str(`${row.name}`) +
                            "</a>"
                        )
                    },
                },
                {
                    title: __("Value"),
                    data: "ledger_value",
                    searchable: true,
                    orderable: true,
                }
            ]
        },
    },
    components: {
        KohaTable
    }
}
</script>
