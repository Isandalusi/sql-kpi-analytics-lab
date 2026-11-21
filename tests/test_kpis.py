from src.run_analytics import build_in_memory_db, run_kpi_suite


def test_monthly_kpis_and_mom_growth():
    conn = build_in_memory_db()
    result = run_kpi_suite(conn)
    monthly = result["monthly_kpis"]

    assert [row["year_month"] for row in monthly] == ["2026-01", "2026-02", "2026-03"]
    assert monthly[0]["approved_gmv_usd"] == 15700.0
    assert monthly[0]["approval_rate_pct"] == 100.0
    assert monthly[0]["mom_gmv_growth_pct"] is None

    # Feb: 14200 + 9800 + 1450 = 25450 approved out of 4 tx (75% approval)
    assert monthly[1]["approved_gmv_usd"] == 25450.0
    assert monthly[1]["approval_rate_pct"] == 75.0
    assert monthly[1]["sla_breach_pct"] == 25.0
    assert monthly[1]["mom_gmv_growth_pct"] == 62.1


def test_customer_risk_and_revenue_ranking():
    conn = build_in_memory_db()
    result = run_kpi_suite(conn)
    ranking = result["customer_risk_ranking"]

    assert ranking[0]["company_name"] == "Andes Logística SA"
    assert ranking[0]["revenue_rank"] == 1
    assert ranking[0]["risk_events"] == 0

    delta = next(r for r in ranking if r["company_name"] == "Delta Distribuidora")
    assert delta["risk_events"] == 1
    assert delta["max_to_avg_ratio"] == 1.56
