import { createApp } from "vue";
import { createWebHistory, createRouter } from "vue-router";

import App from "./components/Main.vue";
import { routes } from './routes/routes.js'

const router = createRouter({
    history: createWebHistory(),
    linkActiveClass: "current",
    routes,
});

const app = createApp(App)
app.use(router)

app.mount("#__app")