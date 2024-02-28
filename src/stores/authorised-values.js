import { defineStore } from "pinia";

export const useAVStore = defineStore("authorised_values", {
    state: () => ({
        acquire_fund_types: [],
    }),
    actions: {
        get_lib_from_av(arr_name, av) {
            if (this[arr_name] === undefined) {
                console.warn(
                    "The authorised value category for '%s' is not defined.".format(
                        arr_name
                    )
                );
                return;
            }
            let o = this[arr_name].find(e => e.value == av);
            return o ? o.description : av;
        },
        map_av_dt_filter(arr_name) {
            return this[arr_name].map(e => {
                e["_id"] = e["value"];
                e["_str"] = e["description"];
                return e;
            });
        },
    },
});
