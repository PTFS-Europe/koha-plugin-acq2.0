import { markRaw } from "vue";

import Homepage from '../components/Homepage.vue'
import SettingsHome from '../components/Settings/SettingsHome.vue'
import ModuleSettings from '../components/Settings/ModuleSettings.vue'
import FundManagementHome from '../components/FundManagement/FundManagementHome.vue'
import FiscalYearList from '../components/FundManagement/FiscalYearList.vue'
import FiscalYearShow from '../components/FundManagement/FiscalYearShow.vue'
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
                moduleName: "funds",
                title: "Funds and ledgers",
                icon: "fa fa-money-check-dollar",
                children: [
                    {
                        path: "",
                        component: markRaw(FundManagementHome),
                        permissions: ['budget_add_del'],
                        name: "FundManagementHome",
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
                                path: ":fiscal_yr_id",
                                component: markRaw(FiscalYearShow),
                                name: "FiscalYearShow",
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
                path: "/acquisitions/tasks",
                title: "Tasks",
                moduleName: "tasks",
                icon: "fa fa-list-check",
                is_end_node: true,
                children: [
                    {
                        path: "",
                        component: markRaw(SettingsHome),
                        name: "TasksHome",
                        is_navigation_item: false,
                    }
                ]
            },
            {
                path: "/acquisitions/settings",
                title: "Settings",
                moduleName: "settings",
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
                    {
                        path: "tasks",
                        component: markRaw(ModuleSettings),
                        name: "ModuleSettingsTasks",
                        title: "Tasks",
                        is_navigation_item: false,
                    },
                    {
                        path: "funds",
                        component: markRaw(ModuleSettings),
                        name: "ModuleSettingsFunds",
                        title: "Funds",
                        is_navigation_item: false,
                    },
                ]
            },
        ]
    }
]