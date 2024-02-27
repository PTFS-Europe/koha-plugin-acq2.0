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
            get: id =>
                this.get({
                    endpoint: "tasks/" + id,
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
            create: fiscal_year =>
                this.post({
                    endpoint: "tasks",
                    body: fiscal_year,
                }),
            update: (fiscal_year, id) =>
                this.put({
                    endpoint: "tasks/" + id,
                    body: fiscal_year,
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

    get fiscal_years() {
        return {
            get: (id, embed) =>
                this.get({
                    endpoint: "fiscal_years/" + id,
                    ...(embed && {
                        headers: {
                            "x-koha-embed": embed
                        }
                    })
                }),
            getAll: (query, params) =>
                this.getAll({
                    endpoint: "fiscal_years",
                    query,
                    params,
                }),
            delete: id =>
                this.delete({
                    endpoint: "fiscal_years/" + id,
                }),
            create: fiscal_year =>
                this.post({
                    endpoint: "fiscal_years",
                    body: fiscal_year,
                }),
            update: (fiscal_year, id) =>
                this.put({
                    endpoint: "fiscal_years/" + id,
                    body: fiscal_year,
                }),
            count: (query = {}) =>
                this.count({
                    endpoint:
                        "fiscal_years?" +
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
            get: (id, embed) =>
                this.get({
                    endpoint: "ledgers/" + id,
                    ...(embed && { headers: {
                        "x-koha-embed": embed
                    }})
                }),
            getAll: (query, params) =>
                this.getAll({
                    endpoint: "ledgers",
                    query,
                    params,
                }),
            delete: id =>
                this.delete({
                    endpoint: "ledgers/" + id,
                }),
            create: fiscal_year =>
                this.post({
                    endpoint: "ledgers",
                    body: fiscal_year,
                }),
            update: (fiscal_year, id) =>
                this.put({
                    endpoint: "ledgers/" + id,
                    body: fiscal_year,
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
}

export default AcquisitionAPIClient;
