import { markRaw } from "vue";

import Homepage from '../components/Homepage.vue'

import SettingsHome from '../components/Settings/SettingsHome.vue'
import ModuleSettings from '../components/Settings/ModuleSettings.vue'

import ManualHome from '../components/Manual/ManualHome.vue'

import TaskList from '../components/TaskManagement/TaskList.vue'
import TaskShow from '../components/TaskManagement/TaskShow.vue'
import TaskFormAdd from '../components/TaskManagement/TaskFormAdd.vue'

import FundManagementHome from '../components/FundManagement/FundManagementHome.vue'
import FiscalPeriodList from '../components/FundManagement/FiscalPeriodList.vue'
import FiscalPeriodShow from '../components/FundManagement/FiscalPeriodShow.vue'
import FiscalPeriodFormAdd from '../components/FundManagement/FiscalPeriodFormAdd.vue'
import LedgerList from '../components/FundManagement/LedgerList.vue'
import LedgerShow from '../components/FundManagement/LedgerShow.vue'
import LedgerFormAdd from '../components/FundManagement/LedgerFormAdd.vue'
import FundList from '../components/FundManagement/FundList.vue'
import FundShow from '../components/FundManagement/FundShow.vue'
import FundFormAdd from '../components/FundManagement/FundFormAdd.vue'
import SubFundFormAdd from '../components/FundManagement/SubFundFormAdd.vue'
import FundGroupList from '../components/FundManagement/FundGroupList.vue'
import FundGroupShow from '../components/FundManagement/FundGroupShow.vue'
import FundGroupFormAdd from '../components/FundManagement/FundGroupFormAdd.vue'
import FundAllocationShow from '../components/FundManagement/FundAllocationShow.vue'
import FundAllocationFormAdd from '../components/FundManagement/FundAllocationFormAdd.vue'
import TransferFunds from '../components/FundManagement/TransferFunds.vue'

import { $__ } from "../i18n";

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
                title: $__("Funds and ledgers"),
                icon: "fa fa-money-check-dollar",
                children: [
                    {
                        path: "",
                        component: markRaw(FundManagementHome),
                        name: "FundManagementHome",
                        is_navigation_item: false,
                    },
                    {
                        path: "fiscal_period",
                        title: "Fiscal periods",
                        is_navigation_item: false,
                        children: [
                            {
                                path: "",
                                component: markRaw(FiscalPeriodList),
                                name: "FiscalPeriodList",
                                title: "List fiscal periods",
                                permission: "manageFiscalPeriods"
                            },
                            {
                                path: ":fiscal_period_id",
                                component: markRaw(FiscalPeriodShow),
                                name: "FiscalPeriodShow",
                                title: "Show fiscal period",
                                permission: "manageFiscalPeriods"
                            },
                            {
                                path: "add",
                                component: markRaw(FiscalPeriodFormAdd),
                                name: "FiscalPeriodFormAdd",
                                title: "Add fiscal period",
                                permission: "createFiscalPeriods"
                            },
                            {
                                path: "edit/:fiscal_period_id",
                                component: markRaw(FiscalPeriodFormAdd),
                                name: "FiscalPeriodFormEdit",
                                title: "Edit fiscal period",
                                permission: "editFiscalPeriod"
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
                                permission: "manageFunds"
                            },
                            {
                                path: ":fund_id",
                                component: markRaw(FundShow),
                                name: "FundShow",
                                title: "Show fund",
                                permission: "manageFunds"
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
                                path: ":fund_id/:sub_fund_id?/allocate",
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
                            {
                                path: ":fund_id/sub_fund/add",
                                component: markRaw(SubFundFormAdd),
                                name: "SubFundFormAdd",
                                title: "Add sub fund",
                                permission: "createFund"
                            },
                            {
                                path: ":fund_id/sub_fund/edit/:sub_fund_id",
                                component: markRaw(SubFundFormAdd),
                                name: "SubFundFormAddEdit",
                                title: "Edit sub fund",
                                permission: "editFund"
                            },
                            {
                                path: "sub_fund/:sub_fund_id",
                                component: markRaw(FundShow),
                                name: "SubFundShow",
                                title: "Show sub fund",
                                permission: "manageFunds"
                            },
                        ]
                    },
                    {
                        path: "fund_group",
                        title: "Fund groups",
                        is_navigation_item: false,
                        children: [
                            {
                                path: "",
                                component: markRaw(FundGroupList),
                                name: "FundGroupList",
                                title: "List fund groups",
                                permission: "manageFundGroups"
                            },
                            {
                                path: ":fund_group_id",
                                component: markRaw(FundGroupShow),
                                name: "FundGroupShow",
                                title: "Show fund group",
                                permission: "manageFundGroups"
                            },
                            {
                                path: "add",
                                component: markRaw(FundGroupFormAdd),
                                name: "FundGroupFormAdd",
                                title: "Add fund group",
                                permission: "createFundGroup"
                            },
                            {
                                path: "edit/:fund_group_id",
                                component: markRaw(FundGroupFormAdd),
                                name: "FundGroupFormEdit",
                                title: "Edit fund group",
                                permission: "editFundGroup"
                            }
                        ]
                    }
                ]
            },
            {
                path: "/acquisitions/tasks",
                title: $__("Tasks"),
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
                title: $__("Settings"),
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