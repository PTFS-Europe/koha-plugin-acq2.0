<template>
    <aside>
        <div id="navmenu">
            <div id="navmenulist">
                <h5>Acquisitions</h5>
                <ul>
                    <li>
                        <span>
                            <router-link
                                :to="{ name: 'FundsHome' }"
                            >
                                <span>Fund management</span>
                            </router-link>
                        </span>
                    </li>
                </ul>
            </div>
        </div>
    </aside>
</template>

<script>

export default {
    name: "NavMenu",
    data() {

        return {
            entities: []
        }
    }
}
</script>

<style scoped>
#navmenulist a.router-link-active {
    font-weight: 700;
}
#menu ul ul,
#navmenulist ul ul {
    padding-left: 2em;
    font-size: 100%;
}

#navmenulist ul li a.disabled {
    color: #666;
    pointer-events: none;
    font-weight: 700;
}
#navmenulist ul li a.disabled.router-link-active {
    color: #000;
}
span.item-last {
    padding: 7px 3px;
}
</style>
