<template>
    <div v-if="!initialized">Loading...</div>
    <div v-else id="ledgers_show">
        <h2>
            {{ "Ledger " + ledger.ledger_id }}
            <span class="action_links">
                <router-link
                    :to="{
                        name: 'LedgerFormEdit',
                        params: { ledger_id: ledger.ledger_id },
                    }"
                    title="Edit"
                    ><i class="fa fa-pencil"></i
                ></router-link>
                <a @click="delete_ledger(ledger.ledger_id, ledger.code)"
                    ><i class="fa fa-trash"></i
                ></a>
            </span>
        </h2>
        <DisplayDataFields 
            :data="ledger"
            homeRoute="LedgerList"
            dataType="ledger"
        />
    </div>
</template>

<script>
import { inject } from "vue"
import { APIClient } from "../../fetch/api-client.js"
import DisplayDataFields from "../DisplayDataFields.vue"

export default {
    setup() {
        const { setConfirmationDialog, setMessage } = inject("mainStore")

        return {
            setConfirmationDialog,
            setMessage,
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
            await client.ledgers.get(ledger_id).then(
                ledger => {
                    this.ledger = ledger
                    console.log(this.ledger)
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
        DisplayDataFields
    },
}
</script>

<style scoped>
.action_links a {
    padding-left: 0.2em;
    font-size: 11px;
    cursor: pointer;
}
</style>