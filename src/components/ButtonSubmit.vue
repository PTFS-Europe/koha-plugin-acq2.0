<template>
    <input type="submit" variant="primary" :value="text" />
</template>

<script>
export default {
    name: "ButtonSubmit",
    props: {
        text: {
            type: String,
            default: "Submit",
            required: false,
        },
    },
}
</script>
