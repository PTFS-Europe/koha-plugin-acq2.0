<template>
    <Toolbar>
        <ToolbarLink
            :to="{ name: 'FiscalYearList' }"
            icon="pen-to-square"
            title="Manage fiscal years"
            v-if="isUserPermitted('manage_fiscal_years')"
        />
        <ToolbarLink
            :to="{ name: 'LedgerList' }"
            icon="pen-to-square"
            title="Manage ledgers"
            v-if="isUserPermitted('manage_ledgers')"
        />
        <ToolbarLink
            :to="{ name: 'FundList' }"
            icon="pen-to-square"
            title="Manage funds"
            v-if="isUserPermitted('manage_funds')"
        />
        <ToolbarLink
            :to="{ name: 'TaskFormAdd' }"
            icon="plus"
            title="New task"
        />
    </Toolbar>
    <h1>Funds and ledgers</h1>
</template>

<script>
import Toolbar from "../Toolbar.vue"
import ToolbarLink from "../ToolbarLink.vue"
import { inject } from "vue"

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
    components: {
        Toolbar,
        ToolbarLink
    }
}
</script>

<style scoped>

</style>