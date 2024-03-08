<template>
    <Dashboard 
        :key="dashboardUpdated"
        pageTitle="Acquisitions home"
    />
</template>

<script>
import { inject } from "vue"
import { storeToRefs } from "pinia"
import { setWarning } from "./../messages"
import Dashboard from "./Dashboard/Dashboard.vue"

export default {
    setup() {
        const acquisitionsStore = inject("acquisitionsStore")
        const { 
            navigationBlocked
        } = storeToRefs(acquisitionsStore)

        const dashboardStore = inject("dashboardStore")
        const {
            dashboardUpdated
        } = storeToRefs(dashboardStore)

        return {
            navigationBlocked,
            dashboardUpdated
        }
    },
	beforeCreate() {
		if(this.navigationBlocked) {
			setWarning("You did not have the required permissions to access that page. Please contact your system administrator.")
			this.navigationBlocked = false
		}
	},
    components: {
        Dashboard
    }
}
</script>

<style scoped>
#acquisitions-dashboard {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    padding: 1em;
    gap: 3em;
    width: 100%;
    height: 100vh;
}
</style>