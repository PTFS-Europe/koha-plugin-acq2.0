<template>
    <button :to="to" :class="class" @click="handleClick"
        ><font-awesome-icon v-if="icon" :icon="icon" /> {{ title }}</button
    >
</template>

<script>
export default {
    props: {
        to: {
            type: [String, Object],
            required: false
        },
        class: {
            type: String,
            default: "btn btn-default",
        },
        icon: {
            type: String,
            required: false,
        },
        title: {
            type: String,
        }
    },
    emits: ['clicked'],
    methods: {
        handleClick() {
            this.$emit('clicked')
        }
    },
}
</script>
