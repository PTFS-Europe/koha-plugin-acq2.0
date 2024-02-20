import { defineStore } from "pinia";

export const useAcquisitionsStore = defineStore("acquisitions", {
    state: () => ({
        user: {
            logged_in_user: null,
            userflags: null,
            library_groups: null
        },
        settings: null,
        permittedUsers: null
    })
});
