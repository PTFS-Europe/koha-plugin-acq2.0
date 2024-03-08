<template>
    <div id="widget-wrapper">
        <slot />
    </div>
</template>

<script>
export default {
    props: {
        manager: Boolean
    }
}
</script>

<style scoped>
#widget-wrapper {
    border: 2px solid lightgray;
    padding: 1em;
    border-radius: 10px;
}
</style>