import { defineStore } from "pinia";

export const useDashboardStore = defineStore("dashboard", {
    state: () => ({
        manageDashboard: null,
        displayedAlready: false,
        widgetList: [
            "topthreeledgersbyvalue",
            "topthreefundsbyvalue",
            "ledgerswithnooverspend"
        ],
        wasDashboardUpdated: 0
    }),
    actions: {
        showDashboardManager(manageDashboard, displayed = true) {
            this.manageDashboard = manageDashboard;
            this.displayedAlready =
                displayed; /* Is displayed on the current view */
        },
        hideDashboardManager() {
            this.manageDashboard = null;
        },
    },
    getters: {
        dashboardUpdated() {
            return this.wasDashboardUpdated
        }
    }
});
