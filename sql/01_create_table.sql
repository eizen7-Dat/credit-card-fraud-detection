CREATE TABLE transactions (
    time_seconds NUMERIC,
    v1 NUMERIC, v2 NUMERIC, v3 NUMERIC, v4 NUMERIC, v5 NUMERIC,
    v6 NUMERIC, v7 NUMERIC, v8 NUMERIC, v9 NUMERIC, v10 NUMERIC,
    v11 NUMERIC, v12 NUMERIC, v13 NUMERIC, v14 NUMERIC, v15 NUMERIC,
    v16 NUMERIC, v17 NUMERIC, v18 NUMERIC, v19 NUMERIC, v20 NUMERIC,
    v21 NUMERIC, v22 NUMERIC, v23 NUMERIC, v24 NUMERIC, v25 NUMERIC,
    v26 NUMERIC, v27 NUMERIC, v28 NUMERIC,
    amount NUMERIC,
    class INTEGER
);

-- Los datos se cargaron mediante la herramienta Import/Export de pgAdmin,
-- importando el archivo data/processed/creditcard_clean.csv