<template>
    <li v-if="item.type === 'string'">
        <label>{{ item.label }}:</label>
        <span>
            {{ item.value }}
        </span>
    </li>
    <li v-if="item.type === 'enum'">
        <label>{{ item.label }}:</label>
        <span>
            {{ item.options[item.value] }}
        </span>
    </li>
    <li v-if="item.type === 'percentage'">
        <label>{{ item.label }}:</label>
        <span>
            {{ parseFloat(item.value) * 100 }}%
        </span>
    </li>
    <li v-if="item.type === 'number'">
        <label>{{ item.label }}:</label>
        <span>
            {{ parseFloat(item.value).toFixed(2) }}
        </span>
    </li>
    <li v-if="item.type === 'owner'">
        <label>{{ item.label }}:</label>
        <span>
            {{ `${item.value.firstname} ${item.value.surname}` }}
        </span>
    </li>
    <li v-if="item.type === 'creator'">
        <label>{{ item.label }}:</label>
        <span>
            {{ `${item.value.firstname} ${item.value.surname}` }}
        </span>
    </li>
    <li v-if="item.type === 'visibility_table'">
        <label>{{ item.label }}:</label>
        <table>
            <thead>
                <th>ID</th>
                <th>Title</th>
            </thead>
            <tr
                v-for="(item, key) in item.value"
                v-bind:key="key"
            >
                <td>{{ item.id }}</td>
                <td>{{ item.title }}</td>
            </tr>
        </table>
    </li>
</template>

<script>

export default {
    props:{
        item: Object
    },
    data() {
        return {}
    }
}
</script>

<style scoped>
fieldset.rows label {
    width: 15em;
}
</style>