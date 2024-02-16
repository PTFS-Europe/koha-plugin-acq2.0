import FundsHome from '../components/FundManagement/FundsHome.vue'

export const routes = [
    {
        path: "/",
        name: "Homepage",
        children: [
            {
                path: "acquisitions/funds",
                name: "FundManagement",
                children: [
                    {
                        path: "",
                        name: "FundsHome",
                        component: FundsHome,
                    }
                ]
            }
        ]
    }
]