import { markRaw } from "vue";

import Homepage from '../components/Homepage.vue'
import SettingsHome from '../components/Settings/SettingsHome.vue'
import ModuleSettings from '../components/Settings/ModuleSettings.vue'
import FundsHome from '../components/FundManagement/FundsHome.vue'
import FiscalYearList from '../components/FundManagement/FiscalYearList.vue'
import FiscalYearFormAdd from '../components/FundManagement/FiscalYearFormAdd.vue'

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
                path: "/acquisitions/fund_management",
                title: "Funds and ledgers",
                icon: "fa fa-money-check-dollar",
                children: [
                    {
                        path: "",
                        component: markRaw(FundsHome),
                        name: "FundsHome",
                        is_navigation_item: false,
                    },
                    {
                        path: "fiscal_year",
                        title: "Fiscal year",
                        is_navigation_item: false,
                        children: [
                            {
                                path: "",
                                component: markRaw(FiscalYearList),
                                name: "FiscalYearList",
                                title: "Add"
                            },
                            {
                                path: "add",
                                component: markRaw(FiscalYearFormAdd),
                                name: "FiscalYearFormAdd",
                                title: "Add"
                            },
                            {
                                path: "edit/:fiscal_yr_id",
                                component: markRaw(FiscalYearFormAdd),
                                name: "FiscalYearFormEdit",
                                title: "Edit"
                            }
                        ]
                    },
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