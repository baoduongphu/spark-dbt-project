# Databricks notebook source
# MAGIC %md
# MAGIC ## Batching Ingestion
# MAGIC

# COMMAND ----------

entities = ['customers', 'trips', 'vehicles', 'locations', 'drivers', 'payments']
for entity in entities:
    df_batch = spark.read.format("csv") \
        .option("header", "true") \
        .option("inferSchema", "true") \
        .load(f"/Volumes/sparkdbt_project/source/{entity}")

    schema = df_batch.schema

    df = spark.readStream\
        .format("csv")\
        .option("header", True)\
        .schema(schema)\
        .load(f"/Volumes/sparkdbt_project/source/{entity}")

    df.writeStream.format("delta")\
        .outputMode("append")\
        .option("checkpointLocation", f"/Volumes/sparkdbt_project/bronze/checkpoints/{entity}")\
        .trigger(availableNow=True)\
        .toTable(f"sparkdbt_project.bronze.{entity}")
