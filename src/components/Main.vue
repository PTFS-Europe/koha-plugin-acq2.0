<template>
    <div v-if="initialized && userPermitted">
        <div id="sub-header">
            <Breadcrumbs />
            <Help />
        </div>
        <div class="main container-fluid">
            <div class="row">
                <div class="col-sm-10 col-sm-push-2">
                    <main>
                        <Dialog />
                        <router-view :key="$route.name" />
                    </main>
                </div>
                <div class="col-sm-2 col-sm-pull-10">
                    <NavMenu
                        :title="'Acquisitions'"
                        :key="modulesEnabled"
                    ></NavMenu>
                </div>
            </div>
        </div>
    </div>
    <div class="main container-fluid" v-else>
        <Dialog />
    </div>
</template>

<script>
import NavMenu from './NavMenu.vue'
import Breadcrumbs from "./Breadcrumbs.vue"
import Help from "./Help.vue"
import Dialog from "./Dialog.vue"
import "vue-select/dist/vue-select.css"
import { inject } from "vue"
import { storeToRefs } from "pinia"
import { APIClient } from "./../fetch/api-client.js"

export default {
    components: {
        NavMenu,
        Breadcrumbs,
        Dialog,
        Help,
    },
    setup() {
        const mainStore = inject("mainStore")
        const { loading, loaded, setError } = mainStore

        const AVStore = inject("AVStore")

        const acquisitionsStore = inject("acquisitionsStore")
        const {
            filterUsersByPermissions,
            filterLibGroupsByUsersBranchcode,
            convertSettingsToObject
        } = acquisitionsStore
        const { 
            user,
            settings,
            libraryGroups,
            permittedUsers,
            modulesEnabled,
            visibleGroups,
            owners,
            currencies
        } = storeToRefs(acquisitionsStore)

        return {
            setError,
            loading,
            loaded,
            settings,
            user,
            libraryGroups,
            permittedUsers,
            modulesEnabled,
            visibleGroups,
            owners,
            filterUsersByPermissions,
            filterLibGroupsByUsersBranchcode,
            convertSettingsToObject,
            AVStore,
            currencies
        }
    },
    data() {
        return {
            initialized: false,
            userPermitted:false
        }
    },
    beforeCreate() {
        this.loading()

        const fetch_config = async () => {
            const patron_client = APIClient.patron
            await patron_client.patrons.getPermittedPatrons().then(
                patrons => {
                    this.permittedUsers = patrons
                    const { permission } = this.$route.meta.self
                    const permissionRequired = permission ? permission : null
                    this.owners = this.filterUsersByPermissions(permissionRequired, false)
                    this.visibleGroups = this.filterLibGroupsByUsersBranchcode()
                },
                error => {}
            )

            const authorised_values = {
                acquire_fund_types: "ACQUIRE_FUND_TYPE"
            }
            const av_cat_array = Object.keys(authorised_values).map(function (
                av_cat
            ) {
                return '"' + authorised_values[av_cat] + '"'
            })
            const av_client = APIClient.authorised_values
            await av_client.values
                .getCategoriesWithValues(av_cat_array)
                .then(av_categories => {
                    Object.entries(authorised_values).forEach(
                        ([av_var, av_cat]) => {
                            const av_match = av_categories.find(
                                element => element.category_name == av_cat
                            )
                            this.AVStore[av_var] =
                                av_match.authorised_values
                        }
                    )
                })
        }

        const acq_client = APIClient.acquisition
        acq_client.settings
            .getAll()
            .then(settings => {
                this.settings = this.convertSettingsToObject(settings)
                this.user.loggedInUser = logged_in_user
                this.user.loggedInUser.loggedInBranch = logged_in_branch.branchcode
                this.user.userflags = userflags
                this.libraryGroups = library_groups
                this.currencies = currencies
                const { acquisition, superlibrarian } = this.user.userflags
                if (!acquisition && !superlibrarian) {
                    return this.setError(
                        'You do not have permission to access this module. Please contact your system administrator.',
                        false
                    )
                }
                this.userPermitted = true
                return fetch_config()
            })
            .then(() => {
                this.loaded()
                this.initialized = true
            })
    }
}
</script>

<style>
#menu ul ul,
#navmenulist ul ul {
    padding-left: 2em;
    font-size: 100%;
}

form .v-select {
    display: inline-block;
    background-color: white;
    width: 30%;
}

.v-select,
input:not([type="submit"]):not([type="search"]):not([type="button"]):not([type="checkbox"]),
textarea {
    border-color: rgba(60, 60, 60, 0.26);
    border-width: 1px;
    border-radius: 4px;
    min-width: 30%;
}
.flatpickr-input {
    width: 30%;
}

#navmenulist ul li a.current.disabled {
    background-color: inherit;
    border-left: 5px solid #e6e6e6;
    color: #000;
}
#navmenulist ul li a.disabled {
    color: #666;
    pointer-events: none;
    font-weight: 700;
}
</style>
