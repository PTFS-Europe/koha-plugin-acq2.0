export const permissionsMatrix = {
    add_task: [],
    edit_task: [],
    delete_task: [],
    manage_fiscal_years: ['period_manage', 'planning_manage'],
    create_fiscal_year: ['planning_manage', 'period_manage'],
    edit_fiscal_year: ['period_manage', 'planning_manage'],
    delete_fiscal_year: ['period_manage', 'planning_manage'],
    manage_ledgers: ['period_manage'],
    create_ledger: ['planning_manage', 'period_manage'],
    edit_ledger: ['period_manage', 'planning_manage'],
    delete_ledger: ['period_manage', 'planning_manage'],
    manage_funds: ['budget_manage'],
    create_fund: ['planning_manage', 'period_manage'],
    edit_fund: ['period_manage', 'planning_manage'],
    delete_fund: ['period_manage', 'planning_manage'],
}