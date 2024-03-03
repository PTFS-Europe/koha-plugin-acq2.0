<template v-if="initialised">
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
import settingsJSON from '../../../Koha/Plugin/Acquire/installer/config/sysprefs.json'
import SettingsCard from './SettingsCard.vue'
import { APIClient } from "../../fetch/api-client.js"
import { inject } from "vue"
import { storeToRefs } from "pinia"

export default {
    setup() {
        const acquisitionsStore = inject("acquisitionsStore")
        const { convertSettingsToObject } = acquisitionsStore
        const { 
            settings,
        } = storeToRefs(acquisitionsStore)

        return {
            settings,
            convertSettingsToObject,
            settingsJSON
        }
    },
    data() {
        return {
            navPanes: [],
            initialised: false
        }
    },
    beforeRouteEnter(to, from, next) {
        next(vm => {
            vm.determineNavPanesToDisplay(settingsJSON)
        })
    },
    methods: {
        async getSettings() {
            const client = APIClient.acquisition
            const settings = await client.settings.getAll().then(
                settings => {
                    this.settings = this.convertSettingsToObject(settings)
                    return settings
                },
                error => {}
            )
            return settings
        },
        async determineNavPanesToDisplay(settingsJSON) {
            const settings = await this.getSettings()
            const { value } = settings.find(i => i.variable === 'modulesEnabled')
            let modulesEnabled = []
            if(value) {
                const selectedModules = value.split("|")
                modulesEnabled = [...selectedModules]
            }
            modulesEnabled.push('manual')
            modulesEnabled.push('general')
            modulesEnabled.push('tasks')

            const modules = Object.keys(settingsJSON)
            const navPanes = modules.map(moduleName => {
                const moduleData = settingsJSON[moduleName]
                return {
                    path: "/acquisitions/settings/" + moduleName,
                    icon: moduleData.icon,
                    title: moduleData.title,
                    module: moduleName
                }
            }).filter(m => modulesEnabled.includes(m.module))
            this.navPanes = navPanes
            this.initialised = true
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