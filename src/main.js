import { createApp } from "vue"
import { createWebHistory, createRouter } from "vue-router"
import { createPinia } from "pinia"
import vSelect from "vue-select";

import App from "./components/Main.vue"
import { routes as routesDef } from './routes/routes.js'
import { useMainStore } from "./stores/main"
import { useNavigationStore } from "./stores/navigation"
import { useAcquisitionsStore } from "./stores/acquisitions"

const pinia = createPinia()
const mainStore = useMainStore(pinia)
const acquisitionsStore = useAcquisitionsStore(pinia)
const navigationStore = useNavigationStore(pinia)
const routes = navigationStore.setRoutes(routesDef)

const router = createRouter({
    history: createWebHistory(),
    linkActiveClass: "current",
    routes,
})

const app = createApp(App)
app.use(router)
app.use(pinia)
app.provide("navigationStore", navigationStore)
app.provide("acquisitionsStore", acquisitionsStore)
app.provide("mainStore", mainStore)
app.component("v-select", vSelect);

app.mount("#__app")

const { removeMessages } = mainStore;
router.beforeEach((to, from) => {
    if(to.matched.length === 0) {
        // The Apache redirect does not render breadcrumbs so we need to push to the correct route
        router.push({ name: "Homepage" })
    } else {
        navigationStore.$patch({ current: to.matched, params: to.params || {} })
    }
    removeMessages(); // This will actually flag the messages as displayed already
})