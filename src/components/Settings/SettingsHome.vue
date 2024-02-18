<template>
    <h1>Settings</h1>
    <div class="navPanesGrid">
        <SettingsCard
            v-for="(item, key) in navPanes"
            v-bind:key="key"
            :item="item"
        ></SettingsCard>
    </div>
</template>

<script>
import settingsJSON from '../../../Koha/Plugin/Acquire/installer/sysprefs/sysprefs.json'
import SettingsCard from './SettingsCard.vue'

export default {
    setup() {
        return {
            settingsJSON
        }
    },
    data() {
        return {
            navPanes: []
        }
    },
    beforeRouteEnter(to, from, next) {
        next(vm => {
            vm.createNavPanes(settingsJSON)
        })
    },
    methods: {
        createNavPanes(settingsJSON) {
            const modules = Object.keys(settingsJSON)
            const navPanes = modules.map(module => {
                const moduleData = settingsJSON[module]
                return {
                    path: "/acquisitions/settings/" + module,
                    icon: moduleData.icon,
                    title: moduleData.title,
                }
            })
            this.navPanes = navPanes
            return navPanes
        }
    },
    components: { SettingsCard },
}
</script>

<style>
.navPanesGrid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    padding: 1em;
    gap: 3em;
    width: 90%;
}
</style>