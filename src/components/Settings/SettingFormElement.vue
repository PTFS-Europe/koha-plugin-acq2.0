<template>
    <li class="settingFormElement">
        <label :for="item.variable">{{ item.variable }}:</label>
        <span>{{ item.explanation}}</span>
        <v-select
            v-if="item.type === 'multiple'"
            :id="item.variable"
            label="description"
            :reduce="av => av.option"
            :options="item.options"
            :multiple="item.type === 'multiple'"
            class="settingsSelect"
            v-model="model"
        >
            <template #search="{ attributes, events }">
                <input
                    class="vs__search"
                    v-bind="attributes"
                    v-on="events"
                />
            </template>
        </v-select>
    </li>
</template>

<script>

export default {
    props: {
        item: Object,
        modelValue: null
    },
    emits: ["update:modelValue"],
    computed: {
        model: {
            get() {
                return this.modelValue
            },
            set(value) {
                this.$emit("update:modelValue", value)
            },
        },
    }
}
</script>

<style scoped>
.settingFormElement {
    display: flex;
    gap: 1em;
    align-items: center;
}
.settingFormElement label {
    margin-bottom: 0px;
}
</style>