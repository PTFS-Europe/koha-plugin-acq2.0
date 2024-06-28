import { setActivePinia, createPinia } from 'pinia'
import { useAcquisitionsStore } from '../../../../src/stores/acquisitions'

describe("AcquisitionsStore", () => {
    beforeEach(() => {
        setActivePinia(createPinia())
    })

    it("Should determine which branch to use when calling determineBranch()", () => {
        const store = useAcquisitionsStore()
        
        store.user.loggedInUser = { loggedInBranch: "XYZ", branchcode: "123" }
        const branch = store.determineBranch('ABC')
        expect(branch).to.eq("ABC")

        store.user.loggedInUser = { loggedInBranch: "XYZ", branchcode: "123" }
        const branch2 = store.determineBranch()
        expect(branch2).to.eq("XYZ")

        store.user.loggedInUser = { loggedInBranch: null, branchcode: "123" }
        const branch3 = store.determineBranch()
        expect(branch3).to.eq("123")
    })

    it("Should filter library groups by users branchcode when calling filterLibGroupsByUsersBranchcode", () => {
        const store = useAcquisitionsStore()

        store.libraryGroups = cy.getLibraryGroups()
        const filteredGroups = store.filterLibGroupsByUsersBranchcode('TPL')
        
        expect(filteredGroups).to.have.length(3)
        expect(filteredGroups[0].title).to.eq('LibGroup2')
        expect(filteredGroups[1].title).to.eq('LibGroup2 SubGroupC')
        expect(filteredGroups[2].title).to.eq('LibGroup2 SubGroupC SubGroup2')
        
        const filteredGroupsTwo = store.filterLibGroupsByUsersBranchcode('MPL', filteredGroups.map(grp => grp.id))
        expect(filteredGroupsTwo).to.have.length(2)
        expect(filteredGroupsTwo[0].title).to.eq('LibGroup2')
        expect(filteredGroupsTwo[1].title).to.eq('LibGroup2 SubGroupC')
    })

    it("Should filter users by permissions when calling filterUsersByPermissions", () => {
        const store = useAcquisitionsStore()
        store.permittedUsers = [
            {
                "borrowernumber": 1,
                "branchcode": "ABC",
                "firstname": "Test",
                "permissions": {
                    "acquisition": 0,
                    "parameters" : 0,
                    "superlibrarian": 1,
                },
                "surname": "Patron",
            },
            {
                "borrowernumber": 2,
                "branchcode": "XYZ",
                "firstname": "Another",
                "permissions": {
                    "acquisition": 0,
                    "parameters" : 0,
                    "superlibrarian": 0,
                },
                "surname": "Patron",
            }
        ]
        store.permissionsMatrix = {
            testPermission: ['something']
        }

        let filteredUsers = store.filterUsersByPermissions(null)
        expect(filteredUsers).to.have.length(2)
        expect(filteredUsers[0].displayName).to.eq('Test Patron')
        expect(filteredUsers[1].displayName).to.eq('Another Patron')

        filteredUsers = store.filterUsersByPermissions('testPermission')
        expect(filteredUsers).to.have.length(1)
        expect(filteredUsers[0].displayName).to.eq('Test Patron')

        store.permittedUsers.push({
            "borrowernumber": 3,
            "branchcode": "XYZ",
            "firstname": "Permitted",
            "permissions": {
                "acquisition": {
                    "something": 1
                },
                "parameters": 0,
                "superlibrarian": 0,
            },
            "surname": "Patron",
        })

        filteredUsers = store.filterUsersByPermissions('testPermission')
        expect(filteredUsers).to.have.length(2)
        expect(filteredUsers[0].displayName).to.eq('Test Patron')
        expect(filteredUsers[1].displayName).to.eq('Permitted Patron')

        filteredUsers = store.filterUsersByPermissions('testPermission', ['XYZ'])
        expect(filteredUsers).to.have.length(1)
        expect(filteredUsers[0].displayName).to.eq('Permitted Patron')
    })

    it("Should check if a user is permitted to perform an operation when calling isUserPermitted", () => {
        const store = useAcquisitionsStore()
        store.permissionsMatrix = {
            testPermission: ['something'],
            permissionFreeAction: []
        }

        // A super librarian has permission to do anything
        store.user.userflags = {
            acquisition: 0,
            superlibrarian: 1
        }
        expect(store.isUserPermitted('testPermission')).to.eq(true)

        // Generic acquisition permission
        store.user.userflags = {
            acquisition: 1,
        }
        expect(store.isUserPermitted('testPermission')).to.eq(true)
        expect(store.isUserPermitted('permissionFreeAction')).to.eq(true)

        // Specific acquisition permissions
        store.user.userflags = {
            acquisition: {
                something: 1
            },
        }
        expect(store.isUserPermitted('testPermission')).to.eq(true)
        expect(store.isUserPermitted('permissionFreeAction')).to.eq(true)

        // Specific acquisition permissions removed
        store.user.userflags = {
            acquisition: {
                something: 0
            },
        }
        expect(store.isUserPermitted('testPermission')).to.eq(false)
        expect(store.isUserPermitted('permissionFreeAction')).to.eq(true)

        // Multiple permissions for an operation
        store.permissionsMatrix = {
            testPermission: ['something', 'somethingElse'],
            permissionFreeAction: []
        }
        store.user.userflags = {
            acquisition: {
                something: 1,
                somethingElse: 1
            },
        }
        expect(store.isUserPermitted('testPermission')).to.eq(true)
        expect(store.isUserPermitted('permissionFreeAction')).to.eq(true)

        // Missing one permission for an operation
        store.permissionsMatrix = {
            testPermission: ['something', 'somethingElse'],
            permissionFreeAction: []
        }
        store.user.userflags = {
            acquisition: {
                something: 1,
                somethingElse: 0
            },
        }
        expect(store.isUserPermitted('testPermission')).to.eq(false)
        expect(store.isUserPermitted('permissionFreeAction')).to.eq(true)
    })

    it("Should filter library groups based on the owner of an object when calling filterLibraryGroupsByOwner", () => {
        const store = useAcquisitionsStore()

        store.libraryGroups = cy.getLibraryGroups()
        store.user.loggedInUser = { loggedInBranch: "CPL", branchcode: "CPL" }
        store.permittedUsers = [
            {
                "borrowernumber": 1,
                "branchcode": "CPL",
                "firstname": "Test",
                "permissions": {
                    "acquisition": 0,
                    "parameters": 0,
                    "superlibrarian": 1,
                },
                "surname": "Patron",
            },
            {
                "borrowernumber": 2,
                "branchcode": "TPL",
                "firstname": "Another",
                "permissions": {
                    "acquisition": 0,
                    "parameters": 0,
                    "superlibrarian": 1,
                },
                "surname": "Patron",
            }
        ]
        store.permissionsMatrix = {
            testPermission: ['something']
        }
        store.user.userflags = {
            acquisition: 0,
            superlibrarian: 1
        }

        // Return all groups
        store.filterGroupsBasedOnOwner(null, {}, null)
        expect(store.visibleGroups).to.have.length(10)

        // Filter out groups that are not visible to the object
        store.filterGroupsBasedOnOwner(null, {}, [1,2,3,4,5,6,7,8,9,10])
        expect(store.visibleGroups).to.have.length(4)

        // Filter out groups that are not visible to a given owner
        store.filterGroupsBasedOnOwner(1, {})
        expect(store.visibleGroups).to.have.length(10)

        // Filter out groups that are not visible to a given owner with a different branchcode
        store.filterGroupsBasedOnOwner(2, {})
        expect(store.visibleGroups).to.have.length(3)
    })

    it("Should filter owners based on the library group visibility when calling filterOwnersBasedOnGroup", () => {
        const store = useAcquisitionsStore()

        store.libraryGroups = cy.getLibraryGroups()
        store.user.loggedInUser = { loggedInBranch: "CPL", branchcode: "CPL" }
        store.permittedUsers = [
            {
                "borrowernumber": 1,
                "branchcode": "CPL",
                "firstname": "Test",
                "permissions": {
                    "acquisition": 0,
                    "parameters": 0,
                    "superlibrarian": 1,
                },
                "surname": "Patron",
            },
            {
                "borrowernumber": 2,
                "branchcode": "TPL",
                "firstname": "Another",
                "permissions": {
                    "acquisition": 0,
                    "parameters": 0,
                    "superlibrarian": 1,
                },
                "surname": "Patron",
            }
        ]
        store.permissionsMatrix = {
            testPermission: ['something']
        }
        store.user.userflags = {
            acquisition: 0,
            superlibrarian: 1
        }

        // Return all owners
        store.filterOwnersBasedOnGroup([], {}, null)
        expect(store.owners).to.have.length(2)

        // Filter out owners that are not visible to the object
        store.currentPermission = 'testPermission'
        store.filterOwnersBasedOnGroup([1], {})
        expect(store.owners).to.have.length(1)
    })

    it("Should set owners based on permissions when calling setOwnersBasedOnPermissions", () => {
        const store = useAcquisitionsStore()

        store.permittedUsers = [
            {
                "borrowernumber": 1,
                "branchcode": "CPL",
                "firstname": "Test",
                "permissions": {
                    "acquisition": 0,
                    "parameters": 0,
                    "superlibrarian": 1,
                },
                "surname": "Patron",
            },
            {
                "borrowernumber": 2,
                "branchcode": "TPL",
                "firstname": "Another",
                "permissions": {
                    "acquisition": 1,
                    "parameters": 0,
                    "superlibrarian": 0,
                },
                "surname": "Patron",
            }
        ]
        store.permissionsMatrix = {
            testPermission: ['something']
        }

        store.setOwnersBasedOnPermission('testPermission')
        expect(store.owners).to.have.length(2)
        
        store.permittedUsers.push({
            "borrowernumber": 3,
            "branchcode": "TPL",
            "firstname": "Third",
            "permissions": {
                "acquisition": 0,
                "parameters": 0,
                "superlibrarian": 0,
                },
            "surname": "Patron",
        })
        expect(store.owners).to.have.length(2)
    })

    it("Should get settings when calling getSettings", () => {
        const store = useAcquisitionsStore()

        store.settings = {
            "testSetting": {
                "value": "testValue"
            },
            "anotherSetting": {
                "value": "anotherValue"
            }
        }

        let settings = store.getSetting('testSetting')
        expect(settings).to.deep.eql({
            "value": "testValue"
        })

        settings = store.getSetting(['testSetting', "anotherSetting"])
        expect(settings).to.deep.eql([
            {
                "value": "testValue"
            },  
            {
                "value": "anotherValue"
            }
        ])
    })

    it("Should convert the settings array to an object when calling convertSettingsToObject", () => {
        const store = useAcquisitionsStore()

        const settings = store.convertSettingsToObject([
            {
                "variable": "testValue"
            },
            {
                "variable": "anotherValue"
            }
        ])
        expect(settings).to.deep.eql({
            "testValue": {
                "variable": "testValue"
            },
            "anotherValue": {
                "variable": "anotherValue"
            }
        })
    })

    it("Should format library groups ids when calling formatLibraryGroupIds", () => {
        const store = useAcquisitionsStore()

        let ids = store.formatLibraryGroupIds("1|2|3")
        expect(ids ).to.deep.eql([1, 2, 3])

        ids = store.formatLibraryGroupIds("1")
        expect(ids ).to.eql([1])
    })

    it("Should format value with currency when calling formatValueWithCurrency", () => {
        const store = useAcquisitionsStore()

        store.currencies = [
            {
                "currency": "USD",
                "symbol": "$"
            },
            {
                "currency": "GBP",
                "symbol": "£"
            }
        ]

        let value = store.formatValueWithCurrency("USD", 10.12)
        expect(value).to.eql("$10.12")
        value = store.formatValueWithCurrency("GBP", 10.12)
        expect(value).to.eql("£10.12")
    })
})

