<template>
        <div>
            <fieldset class="rows">
                <ol>
                    <DataField 
                        v-for="(item, key) in fields"
                        v-bind:key="key"
                        :item="item"
                    />
                </ol>
            </fieldset>
            <fieldset class="action">
                <router-link
                    :to="{ name: homeRoute }"
                    role="button"
                    class="cancel"
                    >Close</router-link
                >
            </fieldset>
        </div>
</template>

<script>
import schema from '../../Koha/Plugin/Acquire/installer/config/schemaToUI.json'
import DataField from './DataField.vue'

export default {
    props:{
        data: Object,
        dataType: String,
        homeRoute: String
    },
    data() {
        const fields = this.mapValueToField(schema, this.dataType)
        return {
            fields
        }
    },
    methods: {
        mapValueToField(schema, type) {
            const fields = schema[type]
            const result = Object.keys(fields).map(key => {
                const value = this.data[key]
                fields[key].value = value
                if(fields[key].type === 'owner') {
                    fields[key].value = this.data.owned_by
                }
                if(fields[key].type === 'creator') {
                    fields[key].value = this.data.creator
                }
                if(fields[key].type === 'table') {
                    const value = this.data[fields[key].dataType]
                    if(Array.isArray(value)) {
                        fields[key].value = value
                    } else {
                        fields[key].value = [ value ]
                    }
                }
                return fields[key]
            })
            return result
        }
    },
    components: {
        DataField
    }
}
</script>

<style scoped>

</style>