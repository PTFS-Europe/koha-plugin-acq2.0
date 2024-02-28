<template>
    <div v-if="!initialized">Loading...</div>
    <div v-else id="ledgers_show">
        <Toolbar>
            <ToolbarButton
                :to="{ name: 'LedgerFormEdit', params: { ledger_id: ledger.ledger_id } }"
                icon="pencil"
                title="Edit"
                v-if="isUserPermitted('edit_ledger')"
            />
            <ToolbarButton
                to="#"
                icon="trash"
                title="Delete"
                @clicked="delete_ledger(ledger.ledger_id, ledger.name)"
                v-if="isUserPermitted('delete_ledger')"
            />
        </Toolbar>
        <h2>{{ "Ledger " + ledger.ledger_id }}</h2>
        <DisplayDataFields 
            :data="ledger"
            homeRoute="LedgerList"
            dataType="ledger"
        />
    </div>
</template>

<script>
import Toolbar from "../Toolbar.vue"
import ToolbarButton from "../ToolbarButton.vue"
import { inject } from "vue"
import { APIClient } from "../../fetch/api-client.js"
import DisplayDataFields from "../DisplayDataFields.vue"

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
            ledger: {},
            initialized: false,
        }
    },
    beforeRouteEnter(to, from, next) {
        next(vm => {
            vm.ledger = vm.getLedger(to.params.ledger_id)
        })
    },
    methods: {
        async getLedger(ledger_id) {
            const client = APIClient.acquisition
            await client.ledgers.get(ledger_id, "fiscal_yr").then(
                ledger => {
                    this.ledger = ledger
                    this.initialized = true
                },
                error => {}
            )
        },
        delete_ledger: function (ledger_id, ledger_code) {
            this.setConfirmationDialog(
                {
                    title: "Are you sure you want to remove this ledger?",
                    message: ledger_code,
                    accept_label: "Yes, delete",
                    cancel_label: "No, do not delete",
                },
                () => {
                    const client = APIClient.acquisition
                    client.ledgers.delete(ledger_id).then(
                        success => {
                            this.setMessage("Ledger deleted")
                            this.$router.push({ name: "LedgerList" })
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
</style>