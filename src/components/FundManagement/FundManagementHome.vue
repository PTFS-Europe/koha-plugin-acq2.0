<template>
    <Toolbar>
        <ToolbarButton
            :to="{ name: 'SettingsHome' }"
            icon="plus"
            title="Create task"
        />
        <ToolbarButton
            :to="{ name: 'FiscalYearList' }"
            icon="pen-to-square"
            title="Manage fiscal years"
            v-if="isUserPermitted('manage_fiscal_years')"
        />
        <ToolbarButton
            :to="{ name: 'SettingsHome' }"
            icon="pen-to-square"
            title="Manage ledgers"
            v-if="isUserPermitted('manage_ledgers')"
        />
        <ToolbarButton
            :to="{ name: 'SettingsHome' }"
            icon="pen-to-square"
            title="Manage funds"
            v-if="isUserPermitted('manage_funds')"
        />
    </Toolbar>
    <h1>Fund management</h1>
</template>

<script>
import Toolbar from "../Toolbar.vue"
import ToolbarButton from "../ToolbarButton.vue"
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
        ToolbarButton
    }
}
</script>

<style scoped>

</style>