import { markRaw } from "vue";

import Homepage from '../components/Homepage.vue'

import SettingsHome from '../components/Settings/SettingsHome.vue'
import ModuleSettings from '../components/Settings/ModuleSettings.vue'

import ManualHome from '../components/Manual/ManualHome.vue'

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
import FundAllocationShow from '../components/FundManagement/FundAllocationShow.vue'
import FundAllocationFormAdd from '../components/FundManagement/FundAllocationFormAdd.vue'
import TransferFunds from '../components/FundManagement/TransferFunds.vue'


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
                        title: "Fiscal years",
                        is_navigation_item: false,
                        children: [
                            {
                                path: "",
                                component: markRaw(FiscalYearList),
                                name: "FiscalYearList",
                                title: "List fiscal years",
                                permission: "manageFiscalYears"
                            },
                            {
                                path: ":fiscal_yr_id",
                                component: markRaw(FiscalYearShow),
                                name: "FiscalYearShow",
                                title: "Show fiscal year",
                                permission: "manageFiscalYears"
                            },
                            {
                                path: "add",
                                component: markRaw(FiscalYearFormAdd),
                                name: "FiscalYearFormAdd",
                                title: "Add fiscal year",
                                permission: "createFiscalYears"
                            },
                            {
                                path: "edit/:fiscal_yr_id",
                                component: markRaw(FiscalYearFormAdd),
                                name: "FiscalYearFormEdit",
                                title: "Edit fiscal year",
                                permission: "editFiscalYear"
                            }
                        ]
                    },
                    {
                        path: "ledger",
                        title: "Ledgers",
                        is_navigation_item: false,
                        children: [
                            {
                                path: "",
                                component: markRaw(LedgerList),
                                name: "LedgerList",
                                title: "List ledgers",
                                permission: "manageLedgers"
                            },
                            {
                                path: ":ledger_id",
                                component: markRaw(LedgerShow),
                                name: "LedgerShow",
                                title: "Show ledger",
                                permission: "manageLedgers"
                            },
                            {
                                path: "add",
                                component: markRaw(LedgerFormAdd),
                                name: "LedgerFormAdd",
                                title: "Add ledger",
                                permission: "createLedger"
                            },
                            {
                                path: "edit/:ledger_id",
                                component: markRaw(LedgerFormAdd),
                                name: "LedgerFormEdit",
                                title: "Edit ledger",
                                permission: "editLedger"
                            }
                        ]
                    },
                    {
                        path: "fund",
                        title: "Funds",
                        is_navigation_item: false,
                        children: [
                            {
                                path: "",
                                component: markRaw(FundList),
                                name: "FundList",
                                title: "List funds",
                                permission: "mangeFunds"
                            },
                            {
                                path: ":fund_id",
                                component: markRaw(FundShow),
                                name: "FundShow",
                                title: "Show fund",
                                permission: "mangeFunds"
                            },
                            {
                                path: "add",
                                component: markRaw(FundFormAdd),
                                name: "FundFormAdd",
                                title: "Add fund",
                                permission: "createFund"
                            },
                            {
                                path: "edit/:fund_id",
                                component: markRaw(FundFormAdd),
                                name: "FundFormEdit",
                                title: "Edit fund",
                                permission: "editFund"
                            },
                            {
                                path: ":fund_id/allocation",
                                component: markRaw(FundAllocationShow),
                                name: "FundAllocationShow",
                                title: "Show fund allocation",
                                permission: "manageFundAllocations"
                            },
                            {
                                path: ":fund_id/allocation/edit/:fund_allocation_id",
                                component: markRaw(FundAllocationFormAdd),
                                name: "FundAllocationFormEdit",
                                title: "Edit fund allocation",
                                permission: "editFundAllocation"
                            },
                            {
                                path: ":fund_id/allocate",
                                component: markRaw(FundAllocationFormAdd),
                                name: "FundAllocationFormAdd",
                                title: "Allocate funds",
                                permission: "createFundAllocation"
                            },
                            {
                                path: "transfer",
                                component: markRaw(TransferFunds),
                                name: "TransferFunds",
                                title: "Transfer funds",
                                permission: "createFundAllocation"
                            },
                        ]
                    }
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
                        permission: "manageSettings"
                    },
                    {
                        path: "tasks",
                        component: markRaw(ModuleSettings),
                        name: "ModuleSettingsTasks",
                        title: "Tasks",
                        is_navigation_item: false,
                        permission: "manageSettings"
                    },
                    {
                        path: "funds",
                        component: markRaw(ModuleSettings),
                        name: "ModuleSettingsFunds",
                        title: "Funds",
                        is_navigation_item: false,
                        permission: "manageSettings"
                    },
                    {
                        path: "manual",
                        component: markRaw(ManualHome),
                        name: "Manual",
                        title: "Manual",
                        is_navigation_item: false,
                    },
                ]
            }
        ]
    }
]