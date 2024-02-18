import { createApp } from "vue"
import { createWebHistory, createRouter } from "vue-router"
import { createPinia } from "pinia"

import App from "./components/Main.vue"
import { routes as routesDef } from './routes/routes.js'
import { useMainStore } from "./stores/main"
import { useNavigationStore } from "./stores/navigation"

const pinia = createPinia()
const mainStore = useMainStore(pinia)
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
app.provide("mainStore", mainStore)


app.mount("#__app")

const { removeMessages } = mainStore;
router.beforeEach((to, from) => {
    navigationStore.$patch({ current: to.matched, params: to.params || {} })
    removeMessages(); // This will actually flag the messages as displayed already
})