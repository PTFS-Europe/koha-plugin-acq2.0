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
        getLibGroupsForUser(groups) {
            const branch = this.user.logged_in_user.branchcode
            const filteredGroups = []
            this.library_groups.forEach(group => {
                if(group.libraries.find(lib => lib.branchcode === branch)) {
                    filteredGroups.push(group)
                }
            })
            return filteredGroups
        },
        getUsersFilteredByPermission(permissions, all) {
            const filteredUsers = []
            this.permittedUsers.forEach(user => {
                user.displayName = user.firstname + ' ' + user.surname
                if(all) {
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
            const { acquisition, superlibrarian } = this.user.userflags
            if (acquisition === 1 || superlibrarian) {
                return true
            } else {
                permissions.forEach(permission => {
                    if (acquisition[permission]) {
                        return true
                    }
                })
            }
            return false
        }
    }
});
