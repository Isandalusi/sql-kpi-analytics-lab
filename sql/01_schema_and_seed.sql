DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    company_name TEXT NOT NULL,
    segment TEXT NOT NULL CHECK (segment IN ('Enterprise', 'SMB', 'Startup')),
    country TEXT NOT NULL,
    created_at DATE NOT NULL
);

CREATE TABLE transactions (
    tx_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    tx_date DATE NOT NULL,
    amount_usd REAL NOT NULL CHECK (amount_usd > 0),
    status TEXT NOT NULL CHECK (status IN ('Approved', 'Chargeback', 'Declined')),
    sla_hours INTEGER NOT NULL CHECK (sla_hours >= 0)
);

INSERT INTO customers (customer_id, company_name, segment, country, created_at) VALUES
    (1, 'Andes Logística SA', 'Enterprise', 'AR', '2026-01-10'),
    (2, 'Pampa Fintech SRL', 'SMB', 'AR', '2026-01-15'),
    (3, 'Sur Retail Group', 'Enterprise', 'CL', '2026-02-01'),
    (4, 'NubeSoft Studio', 'Startup', 'UY', '2026-02-12'),
    (5, 'Delta Distribuidora', 'SMB', 'AR', '2026-03-03');

INSERT INTO transactions (tx_id, customer_id, tx_date, amount_usd, status, sla_hours) VALUES
    (101, 1, '2026-01-12', 12500.00, 'Approved', 4),
    (102, 1, '2026-02-14', 14200.00, 'Approved', 6),
    (103, 1, '2026-03-18', 15800.00, 'Approved', 5),
    (104, 2, '2026-01-20', 3200.00, 'Approved', 8),
    (105, 2, '2026-02-22', 4100.00, 'Chargeback', 30),
    (106, 2, '2026-03-25', 3900.00, 'Approved', 10),
    (107, 3, '2026-02-05', 9800.00, 'Approved', 12),
    (108, 3, '2026-03-08', 11400.00, 'Declined', 28),
    (109, 4, '2026-02-18', 1450.00, 'Approved', 7),
    (110, 4, '2026-03-21', 1900.00, 'Approved', 9),
    (111, 5, '2026-03-05', 5200.00, 'Approved', 11),
    (112, 5, '2026-03-28', 18500.00, 'Chargeback', 36);
