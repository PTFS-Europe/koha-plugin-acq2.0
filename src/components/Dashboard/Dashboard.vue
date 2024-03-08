<template>
    <Toolbar>
        <ToolbarButton
            icon="pen-to-square"
            title="Manage dashboard"
            @clicked="showDashboardManager(true)"
        />
    </Toolbar>
    <h1>{{ pageTitle }}</h1>
    <DashboardWidgetDisplay 
        :widgetList="selectedWidgets"
        :manager="false"
    />
</template>

<script>
import { inject } from "vue"
import Toolbar from "../Toolbar.vue"
import ToolbarButton from "../ToolbarButton.vue"
import TopThreeLedgersByValue from './Widgets/TopThreeLedgersByValue.vue'
import DashboardWidgetDisplay from './DashboardWidgetDisplay.vue'

export default {
    setup() {
        const dashboardStore = inject("dashboardStore")
        const { showDashboardManager } = dashboardStore
        const acquisitionsStore = inject("acquisitionsStore")
        const { getSetting } = acquisitionsStore
        const { value: selectedWidgets } = getSetting("selectedWidgets")
        const formattedWidgetSelection = selectedWidgets ? selectedWidgets.split("|") : []

        return {
            showDashboardManager,
            selectedWidgets: formattedWidgetSelection
        }
    },
    props: {
        pageTitle: String
    },
    components: {
        Toolbar,
        ToolbarButton,
        TopThreeLedgersByValue,
        DashboardWidgetDisplay
    }
}
</script>

<style scoped>

</style>