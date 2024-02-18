<template>
    <div v-if="config">
        <h1>General settings</h1>
        <form @submit="onSubmit($event)">
            <fieldset class="rows">
                <ol>
                    <SettingFormElement
                        v-for="(item, key) in settings"
                        v-bind:key="key"
                        :item="item"
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

export default {
    components: { SettingFormElement, ButtonSubmit },
    data() {
        return {
            config: null
        }
    },
    beforeRouteEnter(to, from, next) {
        next(vm => {
            vm.formatPrefs(settingsJSON, to.path)
            vm.config = settingsJSON
        })
    },
    methods: {
        formatPrefs(settingsJSON, path) {
            const urlParams = path.split("/").filter(param => param !== '/')
            const module = urlParams.pop()

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
            console.log(e)
        }
    }
}
</script>

<style>

</style>