INSERT IGNORE INTO authorised_value_categories(  category_name, is_system  ) VALUES
    ('ACQUIRE_FUND_TYPE', 1);
INSERT IGNORE INTO authorised_values(  category, authorised_value, lib  ) VALUES
    ('ACQUIRE_FUND_TYPE', "PRINT", "Print materials"),
    ('ACQUIRE_FUND_TYPE', "ELECTRONIC", "Electronic materials"),
    ('ACQUIRE_FUND_TYPE', "SUBSCRIPTION", "Subscription materials"),
    ('ACQUIRE_FUND_TYPE', "MISC", "Miscellaneous expenses");