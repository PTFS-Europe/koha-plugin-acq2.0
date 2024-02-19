<template>
    <div v-if="config">
        <h1>{{ moduleTitle }} Settings</h1>
        <form @submit="onSubmit($event)">
            <fieldset class="rows">
                <ol>
                    <SettingFormElement
                        v-for="(item, key) in settings"
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

export default {
    components: { 
        SettingFormElement, 
        ButtonSubmit 
    },
    data() {
        return {
            config: {
                modulesEnabled: null
            },
            moduleTitle: null,
            settings: []
        }
    },
    beforeRouteEnter(to, from, next) {
        next(vm => {
            vm.formatPrefs(settingsJSON, to.path)
        })
    },
    methods: {
        formatPrefs(settingsJSON, path) {
            const urlParams = path.split("/").filter(param => param !== '/')
            const module = urlParams.pop()
            this.moduleTitle = module.charAt(0).toUpperCase() + module.slice(1)

            const { prefs: settings } = settingsJSON[module]
            if(module === 'general') {
                const moduleOptions = Object.keys(settingsJSON).map(module => {
                    return {
                        option: module,
                        description: settingsJSON[module].title
                    }
                }).filter(module => module.option !== 'general')
                settings.modulesEnabled.options = moduleOptions
            }
            const settingsToRender = Object.keys(settings).map(key => {
                const setting = settings[key]
                setting.variable = key
                return setting
            })
            this.settings = settingsToRender
        },
        onSubmit(e) {
            e.preventDefault()

            const verifiedConfig = this.checkForm(this.config)

            const client = APIClient.acquisition
            client.settings.create(verifiedConfig).then(
                success => {
                    setMessage("Settings updated")
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