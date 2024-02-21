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
        permissions_matrix: {
            manage_fiscal_years: ['period_manage', 'planning_manage'],
            create_fiscal_year: ['planning_manage', 'period_manage'],
            edit_fiscal_year: ['period_manage', 'planning_manage'],
            delete_fiscal_year: ['period_manage', 'planning_manage'],
            manage_ledgers: ['period_manage'],
            manage_funds: ['budget_manage']
        }
    }),
    actions: {
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
        getLibGroupsForUser() {
            const branch = this.user.logged_in_user.branchcode
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
        getUsersFilteredByPermission(operation, returnAll) {
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
            return filteredUsers
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
        }
    }
});
