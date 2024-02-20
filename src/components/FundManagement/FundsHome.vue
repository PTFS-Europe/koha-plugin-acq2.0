<template>
    <Toolbar>
        <ToolbarButton
            :to="{ name: 'FiscalYearList' }"
            icon="pencil"
            title="Manage fiscal years"
        />
        <ToolbarButton
            :to="{ name: 'SettingsHome' }"
            icon="pencil"
            title="Manage ledgers"
        />
        <ToolbarButton
            :to="{ name: 'SettingsHome' }"
            icon="pencil"
            title="Manage funds"
        />
    </Toolbar>
    <h1>Fund management</h1>
</template>

<script>
import Toolbar from "../Toolbar.vue"
import ToolbarButton from "../ToolbarButton.vue"

export default {
    setup() {
        
    },
    components: {
        Toolbar,
        ToolbarButton
    }
}
</script>

<style scoped>

</style>