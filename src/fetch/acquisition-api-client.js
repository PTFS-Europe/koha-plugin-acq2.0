import HttpClient from "./http-client";

export class AcquisitionAPIClient extends HttpClient {
    constructor() {
        super({
            baseURL: "/api/v1/contrib/acquire/",
        });
    }

    get currencies() {
        return {
            getAll: (query, params) =>
                this.get({
                    endpoint: "currencies",
                    query,
                    params,
                }),
        };
    }

    get settings() {
        return {
            getAll: (query, params) =>
                this.get({
                    endpoint: "settings",
                    query,
                    params,
                }),
            create: config =>
                this.post({
                    endpoint: "settings",
                    body: config,
                }),
        };
    }

    get tasks() {
        return {
            get: (id, headers) =>
                this.get({
                    endpoint: "tasks/" + id,
                    ...(headers && {
                        headers
                    })
                }),
            getAll: (query, params) =>
                this.getAll({
                    endpoint: "tasks",
                    query,
                    params,
                }),
            delete: id =>
                this.delete({
                    endpoint: "tasks/" + id,
                }),
            create: fiscal_period =>
                this.post({
                    endpoint: "tasks",
                    body: fiscal_period,
                }),
            update: (fiscal_period, id) =>
                this.put({
                    endpoint: "tasks/" + id,
                    body: fiscal_period,
                }),
            count: (query = {}) =>
                this.count({
                    endpoint:
                        "tasks?" +
                        new URLSearchParams({
                            _page: 1,
                            _per_page: 1,
                            ...(query && { q: JSON.stringify(query) }),
                        }),
                }),
        };
    }

    get fiscalPeriods() {
        return {
            get: (id, headers) =>
                this.get({
                    endpoint: "fiscal_periods/" + id,
                    ...(headers && {
                        headers
                    })
                }),
            getAll: (query, params, headers) =>
                this.getAll({
                    endpoint: "fiscal_periods",
                    query,
                    params,
                    ...(headers && {
                        headers
                    })
                }),
            delete: id =>
                this.delete({
                    endpoint: "fiscal_periods/" + id,
                }),
            create: fiscal_period =>
                this.post({
                    endpoint: "fiscal_periods",
                    body: fiscal_period,
                }),
            update: (fiscal_period, id) =>
                this.put({
                    endpoint: "fiscal_periods/" + id,
                    body: fiscal_period,
                }),
            count: (query = {}) =>
                this.count({
                    endpoint:
                        "fiscal_periods?" +
                        new URLSearchParams({
                            _page: 1,
                            _per_page: 1,
                            ...(query && { q: JSON.stringify(query) }),
                        }),
                }),
        };
    }

    get ledgers() {
        return {
            get: (id, headers) =>
                this.get({
                    endpoint: "ledgers/" + id,
                    ...(headers && { headers })
                }),
            getAll: (query, params, headers) =>
                this.getAll({
                    endpoint: "ledgers",
                    query,
                    params,
                    ...(headers && {
                        headers
                    })
                }),
            delete: id =>
                this.delete({
                    endpoint: "ledgers/" + id,
                }),
            create: ledger =>
                this.post({
                    endpoint: "ledgers",
                    body: ledger,
                }),
            update: (ledger, id) =>
                this.put({
                    endpoint: "ledgers/" + id,
                    body: ledger,
                }),
            count: (query = {}) =>
                this.count({
                    endpoint:
                        "ledgers?" +
                        new URLSearchParams({
                            _page: 1,
                            _per_page: 1,
                            ...(query && { q: JSON.stringify(query) }),
                        }),
                }),
        };
    }

    get funds() {
        return {
            get: (id, headers) =>
                this.get({
                    endpoint: "funds/" + id,
                    ...(headers && { headers })
                }),
            getAll: (query, params, headers) =>
                this.getAll({
                    endpoint: "funds",
                    query,
                    params,
                    ...(headers && {
                        headers
                    })
                }),
            delete: id =>
                this.delete({
                    endpoint: "funds/" + id,
                }),
            create: fund =>
                this.post({
                    endpoint: "funds",
                    body: fund,
                }),
            update: (fund, id) =>
                this.put({
                    endpoint: "funds/" + id,
                    body: fund,
                }),
            count: (query = {}) =>
                this.count({
                    endpoint:
                        "funds?" +
                        new URLSearchParams({
                            _page: 1,
                            _per_page: 1,
                            ...(query && { q: JSON.stringify(query) }),
                        }),
                }),
            getFundGroup: (query, params, headers) =>
                this.getAll({
                    endpoint: "fund_groups",
                    query,
                    params,
                    ...(headers && {
                        headers
                    })
                }),
        };
    }

    get subFunds() {
        return {
            get: (id, headers) =>
                this.get({
                    endpoint: "sub_funds/" + id,
                    ...(headers && { headers })
                }),
            getAll: (query, params, headers) =>
                this.getAll({
                    endpoint: "sub_funds",
                    query,
                    params,
                    ...(headers && {
                        headers
                    })
                }),
            delete: id =>
                this.delete({
                    endpoint: "sub_funds/" + id,
                }),
            create: fund =>
                this.post({
                    endpoint: "sub_funds",
                    body: fund,
                }),
            update: (fund, id) =>
                this.put({
                    endpoint: "sub_funds/" + id,
                    body: fund,
                }),
            count: (query = {}) =>
                this.count({
                    endpoint:
                        "sub_funds?" +
                        new URLSearchParams({
                            _page: 1,
                            _per_page: 1,
                            ...(query && { q: JSON.stringify(query) }),
                        }),
                }),
        };
    }

    get fundAllocations() {
        return {
            get: (id, headers) =>
                this.get({
                    endpoint: "fund_allocations/" + id,
                    ...(headers && {
                        headers
                    })
                }),
            getAll: (query, params, headers) =>
                this.getAll({
                    endpoint: "fund_allocations",
                    query,
                    params,
                    ...(headers && {
                        headers
                    })
                }),
            delete: id =>
                this.delete({
                    endpoint: "fund_allocations/" + id,
                }),
            create: fund_allocation =>
                this.post({
                    endpoint: "fund_allocations",
                    body: fund_allocation,
                }),
            transfer: fund_allocation =>
                this.post({
                    endpoint: "fund_allocations/transfer",
                    body: fund_allocation,
                }),
            update: (fund_allocation, id) =>
                this.put({
                    endpoint: "fund_allocations/" + id,
                    body: fund_allocation,
                }),
            count: (query = {}) =>
                this.count({
                    endpoint:
                        "fund_allocations?" +
                        new URLSearchParams({
                            _page: 1,
                            _per_page: 1,
                            ...(query && { q: JSON.stringify(query) }),
                        }),
                }),
        };
    }

    get fundGroups() {
        return {
            get: (id, headers) =>
                this.get({
                    endpoint: "fund_groups/" + id,
                    ...(headers && {
                        headers
                    })
                }),
            getAll: (query, params, headers) =>
                this.getAll({
                    endpoint: "fund_groups",
                    query,
                    params,
                    ...(headers && {
                        headers
                    })
                }),
            delete: id =>
                this.delete({
                    endpoint: "fund_groups/" + id,
                }),
            create: fund_allocation =>
                this.post({
                    endpoint: "fund_groups",
                    body: fund_allocation,
                }),
            update: (fund_allocation, id) =>
                this.put({
                    endpoint: "fund_groups/" + id,
                    body: fund_allocation,
                }),
            count: (query = {}) =>
                this.count({
                    endpoint:
                        "fund_groups?" +
                        new URLSearchParams({
                            _page: 1,
                            _per_page: 1,
                            ...(query && { q: JSON.stringify(query) }),
                        }),
                }),
        };
    }
}

export default AcquisitionAPIClient;
