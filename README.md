# SQL KPI Analytics Lab (CTEs + Window Functions + Pytest CI)

[![CI - SQL Analytics & Pytest](https://github.com/Isandalusi/sql-kpi-analytics-lab/actions/workflows/ci.yml/badge.svg)](https://github.com/Isandalusi/sql-kpi-analytics-lab/actions/workflows/ci.yml)

Laboratorio práctico de **SQL analítico** orientado a roles de **Analista de Datos, Riesgo, Gestión e IT**, con modelado relacional, consultas con **CTEs** y **Window Functions** (`LAG`, `RANK`), ejecución reproducible sobre **SQLite** desde **Python** y verificación automática con **Pytest** en **GitHub Actions**.

## Métricas y Consultas Implementadas

- **KPIs Mensuales & Crecimiento MoM:** GMV aprobado, tasa de aprobación (`approval_rate_pct`), tasa de incumplimiento de SLA `> 24h` (`sla_breach_pct`) y variación mensual (`LAG() OVER`).
- **Ranking de Clientes & Señales de Riesgo:** volumen aprobado por cliente, conteo de eventos de riesgo (`Chargeback` / `Declined`), ratio pico vs. ticket promedio (`max_to_avg_ratio`) y ranking con `RANK() OVER`.

## Estructura del Proyecto

```text
sql-kpi-analytics-lab/
├── sql/
│   ├── 01_schema_and_seed.sql        # Modelo relacional (customers, transactions) + datos
│   └── 02_kpi_analytics_queries.sql  # CTEs y Window Functions para KPIs y riesgo
├── src/
│   └── run_analytics.py              # Runner SQLite en memoria
├── tests/
│   └── test_kpis.py                  # Validación automatizada de métricas con Pytest
└── .github/workflows/ci.yml
```

## Ejecución Local

```bash
pip install pytest
python src/run_analytics.py
pytest -v
```

## Autor

**Jesús Vega Vicente** — Técnico Analista Programador & Lic. en Gestión Informática (UAI, tesis pendiente)  
- LinkedIn: [linkedin.com/in/jesus-vega-a71399314](https://www.linkedin.com/in/jesus-vega-a71399314/)
- Portfolio Web: [docuflow-ai-pro.netlify.app](https://docuflow-ai-pro.netlify.app/)
