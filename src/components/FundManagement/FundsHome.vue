<template>
    <Toolbar>
        <ToolbarButton
            :to="{ name: 'FiscalYearFormAdd' }"
            icon="plus"
            title="New fiscal year"
        />
        <ToolbarButton
            :to="{ name: 'SettingsHome' }"
            icon="plus"
            title="New ledger"
        />
        <ToolbarButton
            :to="{ name: 'SettingsHome' }"
            icon="plus"
            title="New fund"
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