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
        getLibGroupsForUser() {
            const branch = this.user.logged_in_user.branchcode
            const filteredGroups = []
            this.library_groups.forEach(group => {
                if(group.libraries.find(lib => lib.branchcode === branch)) {
                    filteredGroups.push(group)
                }
            })
            return filteredGroups
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
