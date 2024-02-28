import { markRaw } from "vue";

import Homepage from '../components/Homepage.vue'
import SettingsHome from '../components/Settings/SettingsHome.vue'
import ModuleSettings from '../components/Settings/ModuleSettings.vue'
import TaskList from '../components/TaskManagement/TaskList.vue'
import TaskShow from '../components/TaskManagement/TaskShow.vue'
import TaskFormAdd from '../components/TaskManagement/TaskFormAdd.vue'
import FundManagementHome from '../components/FundManagement/FundManagementHome.vue'
import FiscalYearList from '../components/FundManagement/FiscalYearList.vue'
import FiscalYearShow from '../components/FundManagement/FiscalYearShow.vue'
import FiscalYearFormAdd from '../components/FundManagement/FiscalYearFormAdd.vue'
import LedgerList from '../components/FundManagement/LedgerList.vue'
import LedgerShow from '../components/FundManagement/LedgerShow.vue'
import LedgerFormAdd from '../components/FundManagement/LedgerFormAdd.vue'
import FundList from '../components/FundManagement/FundList.vue'
import FundShow from '../components/FundManagement/FundShow.vue'
import FundFormAdd from '../components/FundManagement/FundFormAdd.vue'

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
                                title: "List",
                                permission: "manage_fiscal_years"
                            },
                            {
                                path: ":fiscal_yr_id",
                                component: markRaw(FiscalYearShow),
                                name: "FiscalYearShow",
                                title: "Show",
                                permission: "manage_fiscal_years"
                            },
                            {
                                path: "add",
                                component: markRaw(FiscalYearFormAdd),
                                name: "FiscalYearFormAdd",
                                title: "Add",
                                permission: "create_fiscal_year"
                            },
                            {
                                path: "edit/:fiscal_yr_id",
                                component: markRaw(FiscalYearFormAdd),
                                name: "FiscalYearFormEdit",
                                title: "Edit",
                                permission: "edit_fiscal_year"
                            }
                        ]
                    },
                    {
                        path: "ledger",
                        title: "Ledger",
                        is_navigation_item: false,
                        children: [
                            {
                                path: "",
                                component: markRaw(LedgerList),
                                name: "LedgerList",
                                title: "List",
                                permission: "manage_ledgers"
                            },
                            {
                                path: ":ledger_id",
                                component: markRaw(LedgerShow),
                                name: "LedgerShow",
                                title: "Show",
                                permission: "manage_ledgers"
                            },
                            {
                                path: "add",
                                component: markRaw(LedgerFormAdd),
                                name: "LedgerFormAdd",
                                title: "Add",
                                permission: "create_ledger"
                            },
                            {
                                path: "edit/:ledger_id",
                                component: markRaw(LedgerFormAdd),
                                name: "LedgerFormEdit",
                                title: "Edit",
                                permission: "edit_ledger"
                            }
                        ]
                    },
                    {
                        path: "fund",
                        title: "Fund",
                        is_navigation_item: false,
                        children: [
                            {
                                path: "",
                                component: markRaw(FundList),
                                name: "FundList",
                                title: "List",
                                permission: "manage_funds"
                            },
                            {
                                path: ":fund_id",
                                component: markRaw(FundShow),
                                name: "FundShow",
                                title: "Show",
                                permission: "manage_funds"
                            },
                            {
                                path: "add",
                                component: markRaw(FundFormAdd),
                                name: "FundFormAdd",
                                title: "Add",
                                permission: "create_fund"
                            },
                            {
                                path: "edit/:fund_id",
                                component: markRaw(FundFormAdd),
                                name: "FundFormEdit",
                                title: "Edit",
                                permission: "edit_fund"
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
                        component: markRaw(TaskList),
                        name: "TaskList",
                        is_navigation_item: false,
                    },
                    {
                        path: ":task_id",
                        component: markRaw(TaskShow),
                        name: "TaskShow",
                        is_navigation_item: false,
                    },
                    {
                        path: "add",
                        component: markRaw(TaskFormAdd),
                        name: "TaskFormAdd",
                        is_navigation_item: false,
                    },
                    {
                        path: "edit/:task_id",
                        component: markRaw(TaskFormAdd),
                        name: "TaskFormEdit",
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