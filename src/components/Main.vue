<template>
    <div class="main container-fluid">
        <div class="row">
            <div class="col-sm-10 col-sm-push-2">
                <main>
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

export default {
    components: {
        NavMenu,
    }
}
</script>

<style>

</style>
