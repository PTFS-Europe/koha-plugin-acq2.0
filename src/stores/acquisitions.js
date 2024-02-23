import { defineStore } from "pinia";

export const useAcquisitionsStore = defineStore("acquisitions", {
    state: () => ({
        user: {
            logged_in_user: null,
            userflags: null,
        },
        library_groups: null,
        settings: null,
        permittedUsers: null,
        visibleGroups: null,
        owners: null,
        moduleList: {
            funds: { name: 'Funds and ledgers', code: "funds" }
        },
        permissions_matrix: {
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
    }),
    actions: {
        determineBranch(code) {
            if(code) { return code }
            const { logged_in_user: { logged_in_branchcode, branchcode } } = this.user
            return logged_in_branchcode ? logged_in_branchcode : branchcode 
        },
        mapSubGroups(group, groupObject, branch) {
            let matched = false
            if (group.libraries.find(lib => lib.branchcode === branch)) {
                groupObject[group.id] = group
                matched = true
            }
            if(group.sub_groups && group.sub_groups.length) {
                group.sub_groups.forEach(grp => {
                    const result = this.mapSubGroups(grp, groupObject, branch)
                    matched = matched ? matched : result
                })
            }
            return matched
        },
        filterLibGroupsByUsersBranchcode(branchcode) {
            const branch = this.determineBranch(branchcode)
            const filteredGroups = {}
            this.library_groups.forEach(group => {
                const matched = this.mapSubGroups(group, filteredGroups, branch)
                // If a sub group has been matched but the parent level group did not, then we should add the parent level group as well
                if (matched && !Object.keys(filteredGroups).find(id => id === group.id)) {
                    filteredGroups[group.id] = group
                }
            })
            return Object.keys(filteredGroups).map(key => {
                return filteredGroups[key]
            }).sort((a,b) => a.id - b.id)
        },
        findBranchcodesInGroup(groups) {
            const codes = []
            groups.forEach(group => {
                group.libraries.forEach(lib => {
                    if(!codes.find(code => code === lib.branchcode)) {
                        codes.push(lib.branchcode)
                    }
                })
            })
            return codes
        },
        filterUsersByPermissions(operation, returnAll, branchcodes) {
            const filteredUsers = []
            this.permittedUsers.forEach(user => {
                user.displayName = user.firstname + ' ' + user.surname
                if(returnAll) {
                    filteredUsers.push(user)
                } else {
                    const { acquisition, superlibrarian } = user.permissions
                    if(acquisition === 1 || superlibrarian) {
                        filteredUsers.push(user)
                    } else {
                        this.permissions_matrix[operation].forEach(permission => {
                            if(acquisition[permission]) {
                                filteredUsers.push(user)
                            }
                        })
                    }
                }
            })
            if(branchcodes) {
                return filteredUsers.filter(user => branchcodes.includes(user.branchcode))
            } else {
                return filteredUsers
            }
        },
        isUserPermitted(operation) {
            if(this.permissions_matrix[operation].length === 0) return true
            const { acquisition, superlibrarian } = this.user.userflags
            if (acquisition === 1 || superlibrarian) {
                return true
            } else {
                const checks = this.permissions_matrix[operation].map(permission => {
                    if (acquisition[permission]) {
                        return true
                    } else {
                        return false
                    }
                })
                const failedChecks = checks.filter(check => !check).length
                return failedChecks ? false :  true
            }
        },
        filterGroupsBasedOnOwner(e, data) {
            const libGroups = this.filterLibGroupsByUsersBranchcode()
            const permittedUsers = this.filterUsersByPermissions(null, true)
            if (!e) {
                this.visibleGroups = libGroups
                this.owners = permittedUsers
                data.visible_to = null
            } else {
                const { branchcode } = permittedUsers.find(user => user.borrowernumber === e)
                this.visibleGroups = this.filterLibGroupsByUsersBranchcode(branchcode)
            }
        },
        filterOwnersBasedOnGroup(e, data) {
            const libGroups = this.filterLibGroupsByUsersBranchcode()
            const permittedUsers = this.filterUsersByPermissions(null, true)
            if (!e.length) {
                this.visibleGroups = libGroups
                this.owners = permittedUsers
                data.owner = null
            } else {
                const groups = libGroups.filter(group => e.includes(group.id))
                const branchcodes = this.findBranchcodesInGroup(groups)
                this.owners = this.filterUsersByPermissions(null, true, branchcodes)
            }
        },
        resetOwnersAndVisibleGroups() {
            this.owners = this.filterUsersByPermissions(null, true)
            this.visibleGroups = this.filterLibGroupsByUsersBranchcode()
        },
        getSetting(input) {
            if( typeof input === 'string') {
                return this.settings[input]
            } else {
                return input.map(setting => {
                    return this.settings[setting]
                })
            }
        },
        convertSettingsToObject(settings) {
            const settingsObject = {}
            settings.forEach(setting => {
                settingsObject[setting.variable] = setting
            })
            return settingsObject
        },
        formatLibraryGroupIds(ids) {
            const groups = ids.includes("|") ? ids.split("|") : [ids]
            const groupIds = groups.map(group => {
                return parseInt(group)
            })
            return groupIds
        }
    },
    getters: {
        modulesEnabled() {
            const modulesEnabled = this.settings.modulesEnabled
            return modulesEnabled.value ? modulesEnabled.value : ''
        },
        getVisibleGroups() {
            return this.visibleGroups
        },
        getOwners() {
            return this.owners
        }
    }
});
