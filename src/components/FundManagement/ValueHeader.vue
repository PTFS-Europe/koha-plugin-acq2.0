<template>
        <h3>{{ "Current total: " + symbol + value }}</h3>
</template>

<script>
export default {
    props: {
        symbol: String,
        value: Number
    }
}
</script>