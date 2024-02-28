<template>
    <div v-if="!initialized">Loading...</div>
    <div v-else id="fiscal_yrs_show">
        <Toolbar>
            <ToolbarButton
                :to="{ name: 'FiscalYearFormEdit', params: { fiscal_yr_id: fiscal_yr.fiscal_yr_id } }"
                icon="pencil"
                title="Edit"
                v-if="isUserPermitted('edit_fiscal_year')"
            />
            <ToolbarButton
                to="#"
                icon="trash"
                title="Delete"
                @clicked="delete_fiscal_yr(fiscal_yr.fiscal_yr_id, fiscal_yr.code)"
                v-if="isUserPermitted('delete_fiscal_year')"
            />
        </Toolbar>
        <h2>{{ "Fiscal year " + fiscal_yr.fiscal_yr_id }}</h2>
        <DisplayDataFields 
            :data="fiscal_yr"
            homeRoute="FiscalYearList"
            dataType="fiscal_year"
        />
    </div>
</template>

<script>
import { inject } from "vue"
import { APIClient } from "../../fetch/api-client.js"
import DisplayDataFields from "../DisplayDataFields.vue"
import Toolbar from "../Toolbar.vue"
import ToolbarButton from "../ToolbarButton.vue"

export default {
    setup() {
        const { setConfirmationDialog, setMessage } = inject("mainStore")

        const acquisitionsStore = inject("acquisitionsStore")
        const { 
            isUserPermitted,
        } = acquisitionsStore

        return {
            setConfirmationDialog,
            setMessage,
            isUserPermitted
        }
    },
    data() {
        return {
            fiscal_yr: {},
            initialized: false,
        }
    },
    beforeRouteEnter(to, from, next) {
        next(vm => {
            vm.fiscal_yr = vm.getFiscalYear(to.params.fiscal_yr_id)
        })
    },
    methods: {
        async getFiscalYear(fiscal_yr_id) {
            const client = APIClient.acquisition
            await client.fiscal_years.get(fiscal_yr_id).then(
                fiscal_yr => {
                    this.fiscal_yr = fiscal_yr
                    this.initialized = true
                },
                error => {}
            )
        },
        delete_fiscal_yr: function (fiscal_yr_id, fiscal_yr_code) {
            this.setConfirmationDialog(
                {
                    title: "Are you sure you want to remove this fiscal year?",
                    message: fiscal_yr_code,
                    accept_label: "Yes, delete",
                    cancel_label: "No, do not delete",
                },
                () => {
                    const client = APIClient.acquisition
                    client.fiscal_years.delete(fiscal_yr_id).then(
                        success => {
                            this.setMessage("Fiscal year deleted")
                            this.$router.push({ name: "FiscalYearList" })
                        },
                        error => {}
                    )
                }
            )
        },
    },
    components: {
        DisplayDataFields,
        Toolbar,
        ToolbarButton
    },
}
</script>
<style scoped>
.action_links a {
    padding-left: 0.2em;
    font-size: 11px;
    cursor: pointer;
}
#fiscal_yr_documents ul {
    padding-left: 0px;
}
</style>