<template>
    <div class="main container-fluid">
        <div id="sub-header">
            <Breadcrumbs />
            <Help />
        </div>
        <div class="row">
            <div class="col-sm-10 col-sm-push-2">
                <main>
                    <Dialog />
                    <router-view :key="$route.name" />
                </main>
            </div>
            <div class="col-sm-2 col-sm-pull-10">
                <NavMenu
                    :title="'Acquisitions'"
                ></NavMenu>
            </div>
        </div>
    </div>
</template>

<script>
import NavMenu from './NavMenu.vue'
import Breadcrumbs from "./Breadcrumbs.vue"
import Help from "./Help.vue"
import Dialog from "./Dialog.vue"
import "vue-select/dist/vue-select.css"
import { inject } from "vue"
import { storeToRefs } from "pinia"

export default {
    components: {
        NavMenu,
        Breadcrumbs,
        Dialog,
        Help,
    },
    setup() {
        const acquisitionsStore = inject("acquisitionsStore")
        const { user, settings } = storeToRefs(acquisitionsStore)
        user.logged_in_user = logged_in_user
        user.userflags = userflags

        return {
            settings,
            user
        }
    },

}
</script>

<style>
#menu ul ul,
#navmenulist ul ul {
    padding-left: 2em;
    font-size: 100%;
}

form .v-select {
    display: inline-block;
    background-color: white;
    width: 30%;
}

.v-select,
input:not([type="submit"]):not([type="search"]):not([type="button"]):not([type="checkbox"]),
textarea {
    border-color: rgba(60, 60, 60, 0.26);
    border-width: 1px;
    border-radius: 4px;
    min-width: 30%;
}
.flatpickr-input {
    width: 30%;
}

#navmenulist ul li a.current.disabled {
    background-color: inherit;
    border-left: 5px solid #e6e6e6;
    color: #000;
}
#navmenulist ul li a.disabled {
    color: #666;
    pointer-events: none;
    font-weight: 700;
}
</style>
