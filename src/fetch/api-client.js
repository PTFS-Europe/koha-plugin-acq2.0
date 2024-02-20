import AcquisitionAPIClient from "./acquisition-api-client";
import VendorAPIClient from "./vendor-api-client";
import AVAPIClient from "./authorised-values-api-client";
import SysprefAPIClient from "./system-preferences-api-client";
import PatronAPIClient from "./patron-api-client";

export const APIClient = {
    acquisition: new AcquisitionAPIClient(),
    vendor: new VendorAPIClient(),
    authorised_values: new AVAPIClient(),
    sysprefs: new SysprefAPIClient(),
    patron: new PatronAPIClient(),
};
