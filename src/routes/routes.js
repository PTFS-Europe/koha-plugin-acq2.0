import SettingsHome from '../components/Settings/SettingsHome.vue'
import FundsHome from '../components/FundManagement/FundsHome.vue'

export const routes = [
    {
        path: "/",
        name: "Homepage",
        children: [
            {
                path: "acquisitions/settings",
                name: "Settings",
                children: [
                    {
                        path: "",
                        name: "SettingsHome",
                        component: SettingsHome,
                    }
                ]
            },
            {
                path: "acquisitions/funds",
                name: "FundManagement",
                children: [
                    {
                        path: "",
                        name: "FundsHome",
                        component: FundsHome,
                    }
                ]
            }
        ]
    }
]