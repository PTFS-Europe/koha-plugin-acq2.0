<template>
    <div id="widget-dashboard">
        <WidgetWrapper v-if="widgetList.includes('topthreeledgersbyvalue')" :manager="manager">
            <TopThreeLedgersByValue />
        </WidgetWrapper>
        <WidgetWrapper v-if="widgetList.includes('topthreefundsbyvalue')">
            <TopThreeFundsByValue />
        </WidgetWrapper>
        <WidgetWrapper v-if="widgetList.includes('ledgerswithnooverspend')">
            <LedgersWithNoOverspend />
        </WidgetWrapper>
        <!--Filler blocks in case not all widget slots are used. Place all widgets above this block -->
        <div
            v-for="(filler, key) in gridFillers"
            v-bind:key="key"
        ></div>
    </div>
</template>

<script>
import TopThreeLedgersByValue from './Widgets/TopThreeLedgersByValue.vue'
import TopThreeFundsByValue from './Widgets/TopThreeFundsByValue.vue'
import LedgersWithNoOverspend from './Widgets/LedgersWithNoOverspend.vue'
import WidgetWrapper from './WidgetWrapper.vue'

export default {
    props: {
        widgetList: Array,
        manager: Boolean
    },
    data() {
        const gridFillers = [1,2,3,4]
        if(this.widgetList.length !== 4) {
            gridFillers.length = 4 - this.widgetList.length
        } else {
            gridFillers.length = 0
        }
        return {
            gridFillers
        }
    },
    components: {
        WidgetWrapper,
        TopThreeFundsByValue,
        TopThreeLedgersByValue,
        LedgersWithNoOverspend
    }
}
</script>

<style scoped>
#widget-dashboard {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    padding: 1em;
    gap: 1.5em;
    width: 100%;
    height: 100vh;
}
</style>