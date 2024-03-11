<template>
    <router-link
        :to="item.path"
        class="navPane"
    >
        <template v-if="item.icon">
            <i :class="`${item.icon}`"></i>&nbsp;
        </template>
        <span v-if="item.title">{{ item.title }}</span>
    </router-link>
</template>

<script>
export default {
    props: {
        item: Object
    }
}
</script>

<style>
.navPane {
    padding: 1em;
    font-size: 25px;
    width: 100%;
    background-color: #E6E6E6;
    border-radius: 10px;
    border: 5px #E6E6E6 solid;
    color: black;
}
.navPane:hover {
    text-decoration: none;
    background-color: #F3F4F4;
    border: 5px #408540 solid;
    color: #006100;
}
</style>