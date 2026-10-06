"""Generate TPCH source tables into a DuckDB file.

Usage: python scripts/generate_tpch.py <db_path> <scale_factor>
Skips generation if the tables already exist.
"""
import sys

import duckdb

path = sys.argv[1] if len(sys.argv) > 1 else "dev.duckdb"
scale = float(sys.argv[2]) if len(sys.argv) > 2 else 1.0

con = duckdb.connect(path)
con.install_extension("tpch")
con.load_extension("tpch")

exists = con.execute(
    "select count(*) from information_schema.tables where table_name = 'lineitem'"
).fetchone()[0]

if exists:
    print(f"{path}: TPCH tables already exist, skipping")
else:
    con.execute(f"CALL dbgen(sf={scale})")

rows = con.execute("select count(*) from lineitem").fetchone()[0]
print(f"{path}: lineitem has {rows} rows")
