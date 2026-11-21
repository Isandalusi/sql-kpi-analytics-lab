import sqlite3
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SCHEMA_PATH = ROOT / "sql" / "01_schema_and_seed.sql"
QUERIES_PATH = ROOT / "sql" / "02_kpi_analytics_queries.sql"


def build_in_memory_db() -> sqlite3.Connection:
    conn = sqlite3.connect(":memory:")
    conn.row_factory = sqlite3.Row
    conn.executescript(SCHEMA_PATH.read_text(encoding="utf-8"))
    return conn


def run_kpi_suite(conn: sqlite3.Connection) -> dict[str, list[dict]]:
    raw = QUERIES_PATH.read_text(encoding="utf-8")
    statements = [stmt.strip() for stmt in raw.split(";") if stmt.strip()]
    monthly_rows = [dict(r) for r in conn.execute(statements[0]).fetchall()]
    customer_rows = [dict(r) for r in conn.execute(statements[1]).fetchall()]
    return {"monthly_kpis": monthly_rows, "customer_risk_ranking": customer_rows}


if __name__ == "__main__":
    connection = build_in_memory_db()
    report = run_kpi_suite(connection)
    print("Monthly KPIs:", report["monthly_kpis"])
    print("Customer Risk Ranking:", report["customer_risk_ranking"])
