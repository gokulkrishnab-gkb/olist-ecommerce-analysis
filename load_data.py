import sqlite3, glob, os
import pandas as pd

conn = sqlite3.connect("olist.db")

for f in glob.glob("data/*.csv"):
    name = os.path.basename(f).replace("olist_", "").replace("_dataset.csv", "").replace(".csv", "")
    df = pd.read_csv(f)
    df.to_sql(name, conn, if_exists="replace", index=False)
    print(name, df.shape)

conn.close()