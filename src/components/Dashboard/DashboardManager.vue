<template>
    <div class="modal_centered" v-if="manageDashboard">
        <div class="dashboard-manager">
            <i id="close_modal" class="fa fa-fw fa-close" @click="hideDashboardManager"></i>
            <h1>Dashboard manager</h1>
            <p>You may select up to 4 widgets to display on the dashboard</p>
            <button
                id="submit_dashboard_choices"
                @click="submit"
            >Update dashboard</button>
            <DashboardWidgetDisplay
                :widgetList="widgetList"
                :manager="true"
            />
        </div>
    </div>

    <div class="modal_centered" v-if="is_submitting">
        <div class="spinner dialog alert">{{ "Submitting..." }}</div>
    </div>
    <div class="modal_centered" v-if="is_loading">
        <div class="spinner dialog message">{{ "Loading..." }}</div>
    </div>
</template>

<script>
import { inject } from "vue"
import { storeToRefs } from "pinia"
import { APIClient } from "../../fetch/api-client.js"
import DashboardWidgetDisplay from './DashboardWidgetDisplay.vue'

export default {
    components: { 
        DashboardWidgetDisplay
    },
    setup() {
        const mainStore = inject("mainStore")
        const {
            message,
            error,
            warning,
            confirmation,
            accept_callback,
            is_submitting,
            is_loading,
        } = storeToRefs(mainStore)
        const { removeMessages, removeConfirmationMessages } = mainStore

        const dashboardStore = inject("dashboardStore")
        const {
            manageDashboard,
            wasDashboardUpdated,
            widgetList
        } = storeToRefs(dashboardStore)
        const { showDashboardManager, hideDashboardManager } = dashboardStore

        const acquisitionsStore = inject("acquisitionsStore")
        const {
            settings
        } = storeToRefs(acquisitionsStore)

        return {
            message,
            error,
            warning,
            confirmation,
            accept_callback,
            is_submitting,
            is_loading,
            removeMessages,
            removeConfirmationMessages,
            manageDashboard,
            showDashboardManager,
            hideDashboardManager,
            wasDashboardUpdated,
            settings,
            widgetList
        }
    },
    data() {
        return {
            selectedWidgets: []
        }
    },
    methods: {
        submit(e) {
            e.preventDefault()

            const formattedWidgetSelection = this.selectedWidgets.join("|")
            this.settings.selectedWidgets.value = formattedWidgetSelection

            const widgets = {
                selectedWidgets: formattedWidgetSelection
            }

            const client = APIClient.acquisition
            client.settings.create(widgets).then(
                success => {
                    this.manageDashboard = null
                    this.wasDashboardUpdated = this.wasDashboardUpdated + 1
                },
                error => {}
            )
        }
    }
}
</script>

<style scoped>
#close_modal {
    cursor: pointer;
    position: absolute;
    top: 1em;
    right: 0.8em;
    padding: 0.2em;
}
#close_modal:hover {
    cursor: pointer;
    position: absolute;
    top: 1em;
    right: 0.8em;
    background-color: lightgray;
}
.modal_centered {
    position: fixed;
    z-index: 9998;
    display: table;
    transition: opacity 0.3s ease;
    left: 0px;
    top: 0px;
    width: 100%;
    height: 100%;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.33);
}
.spinner {
    position: absolute;
    top: 50%;
    left: 40%;
    width: 10%;
}
.dashboard-manager {
    height: 100vh;
    width: 100vw;
    background-color: #E6E6E6;
    margin: auto;
    padding: 2em;
    border-radius: 10px;
    position: relative;
    overflow: auto;
}
#submit_dashboard_choices {
    margin-bottom: 2em;
    padding: 0.5em;
}
</style>
