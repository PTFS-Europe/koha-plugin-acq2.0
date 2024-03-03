<template>
    <div id="account_view" class="page-section">
        <table class="accounts_table">
            <tr>
                <th>Description</th>
                <th>Amount</th>
                <th class="centre_column"></th>
                <th>Description</th>
                <th>Amount</th>
            </tr>
            <tr>
                <td>Increase in allocation</td>
                <td>{{ formatValue(data.allocation_increase) }}</td>
                <td class="centre_column"></td>
                <td>Encumbered</td>
                <td>{{ formatValue() }}</td>
            </tr>
            <tr>
                <td>Decrease in allocation</td>
                <td>{{ formatValue(data.allocation_decrease) }}</td>
                <td class="centre_column"></td>
                <td>Awaiting payment</td>
                <td>{{ formatValue() }}</td>
            </tr>
            <tr>
                <td>Total allocated</td>
                <td>{{ formatValue(data.total_allocation) }}</td>
                <td class="centre_column"></td>
                <td>Expended</td>
                <td>{{ formatValue() }}</td>
            </tr>
            <tr>
                <td class="centre_column"></td>
                <td class="centre_column"></td>
                <td class="centre_column"></td>
                <td class="centre_column"></td>
                <td class="centre_column"></td>
            </tr>
            <tr>
                <td>Net transfers</td>
                <td>{{ formatValue(data.net_transfers) }}</td>
                <td class="centre_column"></td>
                <td>Over encumbrance</td>
                <td>{{ formatValue() }}</td>
            </tr>
            <tr>
                <td>Total funding</td>
                <td>{{ formatValue(data.total_allocation) }}</td>
                <td class="centre_column"></td>
                <td>Over expended</td>
                <td>{{ formatValue() }}</td>
            </tr>
            <tr>
                <td>Cash balance</td>
                <td>{{ formatValue(data.total_allocation) }}</td>
                <td class="centre_column"></td>
                <td>Available balance</td>
                <td>{{ formatValue(data.total_allocation) }}</td>
            </tr>
        </table>
    </div>
</template>

<script>
export default {
    setup() {
        
    },
    props: {
        data: Object,
        currencySymbol: String
    },
    methods: {
        formatValue(value) {
            if(!value) {
                return `${this.currencySymbol}0`
            }
            if(value >= 0) {
                return `${this.currencySymbol}${value}`
            }
            if(value < 0) {
                return `-${this.currencySymbol}${-value}`
            }
        }
    }
}

</script>

<style scoped>
#account_view {
    width: 50%;
    margin: 0.9em 0 0;
}
.accounts_table {
    width: 100%;
    /* border: 1px solid #BCBCBC; */
}
.accounts_table th {
    padding: 1em;
}
.accounts_table td {
    padding: 1em 0.5em;
}
.centre_column {
    background-color: #f3f4f4;
}
tbody tr:nth-child(odd):not(.dtrg-group, .active, .ok) td:not(.bg-danger, .bg-warning, .bg-info, .bg-success, .bg-primary, .centre_column) {
    background-color: white;
}
</style>