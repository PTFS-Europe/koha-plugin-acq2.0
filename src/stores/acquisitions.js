import { defineStore } from "pinia";

export const useAcquisitionsStore = defineStore("acquisitions", {
    state: () => ({
        user: {
            logged_in_user: null,
            userflags: null,
        },
        library_groups: null,
        settings: null,
        permittedUsers: null
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
        getUsersFilteredByPermission(permissions, returnAll) {
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
                        permissions.forEach(permission => {
                            if(acquisition[permission]) {
                                filteredUsers.push(user)
                            }
                        })
                    }
                }
            })
            return filteredUsers
        },
        isUserPermitted(permissions) {
            if(permissions.length === 0) return true
            const { acquisition, superlibrarian } = this.user.userflags
            if (acquisition === 1 || superlibrarian) {
                return true
            } else {
                const checks = permissions.map(permission => {
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
