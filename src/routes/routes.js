import { markRaw } from "vue";

import Homepage from '../components/Homepage.vue'
import SettingsHome from '../components/Settings/SettingsHome.vue'
import ModuleSettings from '../components/Settings/ModuleSettings.vue'
import FundsHome from '../components/FundManagement/FundsHome.vue'

export const routes = [
    {
        path: "/acquisitions",
        is_default: true,
        is_base: true,
        title: "Acquisitions",
        children: [
            {
                path: "",
                name: "Homepage",
                component: markRaw(Homepage),
                is_navigation_item: false,
            },
            {
                path: "/acquisitions/funds",
                name: "FundManagement",
                title: "Funds and ledgers",
                component: markRaw(FundsHome),
                is_end_node: true,
                icon: "fa fa-money-check-dollar",
                children: [

                ]
            },
            {
                path: "/acquisitions/settings",
                title: "Settings",
                icon: "fa fa-cog",
                is_end_node: true,
                children: [
                    {
                        path: "",
                        component: markRaw(SettingsHome),
                        name: "SettingsHome",
                        is_navigation_item: false,
                    },
                    {
                        path: "general",
                        component: markRaw(ModuleSettings),
                        name: "ModuleSettingsGeneral",
                        title: "General",
                        is_navigation_item: false,
                    },
                ]
            },
        ]
    }
]