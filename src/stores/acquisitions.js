import { defineStore } from "pinia";
import { permissionsMatrix } from "../data/permissionsMatrix";

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
        navigationBlocked: false,
        currentPermission: null,
        moduleList: {
            funds: { name: 'Funds and ledgers', code: "funds" }
        },
        permissions_matrix: permissionsMatrix,
        currencies: null
    }),
    actions: {
        determineBranch(code) {
            if(code) { return code }
            const { logged_in_user: { logged_in_branch, branchcode } } = this.user
            return logged_in_branch ? logged_in_branch : branchcode 
        },
        mapSubGroups(group, filteredGroups, branch, groupsToCheck) {
            let matched = false
            if (group.libraries.find(lib => lib.branchcode === branch)) {
                if(groupsToCheck && groupsToCheck.length && groupsToCheck.includes(group.id)) {
                    filteredGroups[group.id] = group
                    matched = true    
                }
                if(!groupsToCheck || groupsToCheck.length === 0) {
                    filteredGroups[group.id] = group
                    matched = true    
                }
            }
            if(group.sub_groups && group.sub_groups.length) {
                group.sub_groups.forEach(grp => {
                    const result = this.mapSubGroups(grp, filteredGroups, branch, groupsToCheck)
                    matched = matched ? matched : result
                })
            }
            return matched
        },
        filterLibGroupsByUsersBranchcode(branchcode, groupsToCheck) {
            const branch = this.determineBranch(branchcode)
            const filteredGroups = {}
            this.library_groups.forEach(group => {
                const matched = this.mapSubGroups(group, filteredGroups, branch, groupsToCheck)
                // If a sub group has been matched but the parent level group did not, then we should add the parent level group as well
                // This happens when a parent group doesn't have nay branchcodes assigned to it, only sub groups
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
                    const userPermitted = this.isUserPermitted(operation, user.permissions)
                    if (userPermitted) {
                        filteredUsers.push(user)
                    }
                }
            })
            if(branchcodes) {
                return filteredUsers.filter(user => branchcodes.includes(user.branchcode))
            } else {
                return filteredUsers
            }
        },
        isUserPermitted(operation, flags) {
            const userflags = flags ? flags : this.user.userflags
            if(!operation) return true
            if(this.permissions_matrix[operation].length === 0) return true

            const { acquisition, superlibrarian } = userflags
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
                return failedChecks > 0 ? false :  true
            }
        },
        filterGroupsBasedOnOwner(e, data, groups) {
            const libGroups = this.filterLibGroupsByUsersBranchcode(null, groups)
            const permittedUsers = this.filterUsersByPermissions(this.currentPermission, false)
            if (!e) {
                this.visibleGroups = libGroups
                this.owners = permittedUsers
                data.visible_to = null
            } else {
                const { branchcode } = permittedUsers.find(user => user.borrowernumber === e)
                this.visibleGroups = this.filterLibGroupsByUsersBranchcode(branchcode, groups)
            }
        },
        filterOwnersBasedOnGroup(e, data, groups) {
            const libGroups = this.filterLibGroupsByUsersBranchcode(null, groups)
            const permittedUsers = this.filterUsersByPermissions(this.currentPermission, false, null)
            if (!e.length) {
                this.visibleGroups = libGroups
                this.owners = permittedUsers
                data.owner = null
            } else {
                const groups = libGroups.filter(group => e.includes(group.id))
                const branchcodes = this.findBranchcodesInGroup(groups)
                this.owners = this.filterUsersByPermissions(this.currentPermission, false, branchcodes)
            }
        },
        setOwnersBasedOnPermission(permission) {
            if(this.permittedUsers) {
                this.owners = this.filterUsersByPermissions(permission, false, null)
            }
        },
        resetOwnersAndVisibleGroups(groups) {
            this.owners = this.filterUsersByPermissions(this.currentPermission, false)
            this.visibleGroups = this.filterLibGroupsByUsersBranchcode(null, groups)
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
        },
        getCurrency(currency) {
            return this.currencies.find(curr => curr.currency === currency)
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
