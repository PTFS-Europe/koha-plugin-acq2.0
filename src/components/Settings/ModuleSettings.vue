<template>
    <div v-if="initialized">
        <h1>{{ moduleTitle }} Settings</h1>
        <form @submit="onSubmit($event)">
            <fieldset class="rows">
                <ol>
                    <SettingFormElement
                        v-for="(item, key) in settingsRenderingData"
                        v-bind:key="key"
                        :item="item"
                        v-model="config[item.variable]"
                    ></SettingFormElement>
                </ol>
            </fieldset>
            <fieldset class="action">
                <ButtonSubmit />
                <router-link
                    :to="{ name: 'SettingsHome' }"
                    role="button"
                    class="cancel"
                    >Cancel</router-link
                >
            </fieldset>
        </form>
    </div>
</template>

<script>
import settingsJSON from '../../../Koha/Plugin/Acquire/installer/sysprefs/sysprefs.json'
import SettingFormElement from './SettingFormElement.vue'
import ButtonSubmit from "../ButtonSubmit.vue"
import { setMessage } from "../../messages"
import { APIClient } from "../../fetch/api-client.js"
import { inject } from "vue"
import { storeToRefs } from "pinia"

export default {
    components: { 
        SettingFormElement, 
        ButtonSubmit 
    },
    setup() {
        const acquisitionsStore = inject("acquisitionsStore")
        const { 
            settings,
        } = storeToRefs(acquisitionsStore)

        return {
            settings,
        }
    },
    data() {
        return {
            config: {
                modulesEnabled: null
            },
            moduleTitle: null,
            settingsRenderingData: [],
            initialized: false
        }
    },
    beforeRouteEnter(to, from, next) {
        next(vm => {
            vm.formatPrefs(settingsJSON, to.path)
        })
    },
    methods: {
        async getSettings() {
            const client = APIClient.acquisition
            const settings = await client.settings.getAll().then(
                settings => {
                    this.settings = settings
                    return settings
                },
                error => {}
            )
            return settings
        },
        async formatPrefs(settingsJSON, path) {
            const settings = await this.getSettings()

            const urlParams = path.split("/").filter(param => param !== '/')
            const module = urlParams.pop()
            this.moduleTitle = module.charAt(0).toUpperCase() + module.slice(1)

            const { prefs: settingsBaseData } = settingsJSON[module]
            if(module === 'general') {
                const moduleOptions = Object.keys(settingsJSON).map(module => {
                    return {
                        option: module,
                        description: settingsJSON[module].title
                    }
                }).filter(module => module.option !== 'general')
                settingsBaseData.modulesEnabled.options = moduleOptions
            }
            const settingsRenderingData = Object.keys(settingsBaseData).map(key => {
                const setting = settingsBaseData[key]
                setting.variable = key
                return setting
            })
            this.settingsRenderingData = this.mapSettingsToUI(settings, settingsRenderingData)
            this.initialized = true
        },
        mapSettingsToUI(settings, settingsRenderingData) {
            const settingsToRenderWithValues = settingsRenderingData.map(setting => {
                const pref = settings.find(userSetting => userSetting.variable === setting.variable)
                this.config[setting.variable] = setting.needsSplit ? 
                    pref.value ? 
                        pref.value.split("|") : null 
                    : pref.value
                setting.value = null
                return setting
            })
            return settingsToRenderWithValues
        },
        onSubmit(e) {
            e.preventDefault()

            const verifiedConfig = this.checkForm(this.config)

            const client = APIClient.acquisition
            client.settings.create(verifiedConfig).then(
                success => {
                    setMessage("Settings updated")
                    if(verifiedConfig.hasOwnProperty('modulesEnabled')) {
                        const modulesEnabled = this.settings.find(i => i.variable === 'modulesEnabled')
                        modulesEnabled.value = verifiedConfig.modulesEnabled
                    }
                    this.$router.push({ name: "SettingsHome" })
                },
                error => {}
            )
        },
        checkForm(config) {
            const settings = Object.keys(config)
            settings.forEach(setting => {
                const value = config[setting]
                if( Array.isArray(value) ) {
                    const newValue = value.join("|")
                    config[setting] = newValue
                }
            })
            return config
        }
    }
}
</script>

<style>

</style>