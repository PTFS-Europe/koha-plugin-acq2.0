<template>
    <div class="main container-fluid">
        <div id="sub-header">
            <Breadcrumbs />
            <Help />
        </div>
        <div class="row">
            <div class="col-sm-10 col-sm-push-2">
                <main>
                    <router-view :key="$route.name" />
                    <Dialog />
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

export default {
    components: {
        NavMenu,
        Breadcrumbs,
        Dialog,
        Help,
    }
}
</script>

<style>

</style>
