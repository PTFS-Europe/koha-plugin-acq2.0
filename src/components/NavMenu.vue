<template>
    <aside>
        <div id="navmenu">
            <div id="navmenulist">
                <h5>{{ title }}</h5>
                <ul>
                    <NavigationItem
                        v-for="(item, key) in navigationTree"
                        v-bind:key="key"
                        :item="item"
                    ></NavigationItem>
                </ul>
            </div>
        </div>
    </aside>
</template>

<script>
import { inject } from "vue"
import { storeToRefs } from "pinia"
import NavigationItem from "./NavigationItem.vue"

export default {
    name: "NavMenu",
    data() {
        return {
            navigationTree: this.leftNavigation,
        }
    },
    setup() {
        const navigationStore = inject("navigationStore")
        const { leftNavigation } = navigationStore

        const acquisitionsStore = inject("acquisitionsStore")
        const { 
            settings,
            modulesEnabled
        } = storeToRefs(acquisitionsStore)

        return {
            settings,
            modulesEnabled,
            leftNavigation,
        }
    },
    async beforeMount() {
        let modulesToShow = []
        if(this.modulesEnabled) {
            const selectedModules = this.modulesEnabled.split("|")
            modulesToShow = [...selectedModules]
        }
        modulesToShow.push('settings')
        modulesToShow.push('tasks')
        this.navigationTree = this.navigationTree.filter(route => modulesToShow.includes(route.moduleName))

        if (this.condition)
            this.navigationTree = await this.condition(this.navigationTree)

    },
    props: {
        title: String,
        condition: Function,
    },
    components: {
        NavigationItem,
    },
}
</script>

<style scoped>
#navmenulist a.router-link-active {
    font-weight: 700;
}
#menu ul ul,
#navmenulist ul ul {
    padding-left: 2em;
    font-size: 100%;
}

#navmenulist ul li a.disabled {
    color: #666;
    pointer-events: none;
    font-weight: 700;
}
#navmenulist ul li a.disabled.router-link-active {
    color: #000;
}
</style>