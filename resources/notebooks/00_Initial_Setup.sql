-- Databricks notebook source
-- MAGIC %md
-- MAGIC #Intial Setup:
-- MAGIC This notebook creates the Objects required for the CAPSTONE project.
-- MAGIC
-- MAGIC - Catalog
-- MAGIC - Database
-- MAGIC - Volume

-- COMMAND ----------

CREATE CATALOG IF NOT EXISTS CAPSTONE;

-- COMMAND ----------

USE CATALOG CAPSTONE;

-- COMMAND ----------

SELECT CURRENT_CATALOG();

-- COMMAND ----------

CREATE SCHEMA IF NOT EXISTS CAPSTONE.BRONZE;
CREATE SCHEMA IF NOT EXISTS CAPSTONE.SILVER;
CREATE SCHEMA IF NOT EXISTS CAPSTONE.GOLD;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC # External Volume
-- MAGIC
-- MAGIC  **Unable to create External Volume as I do not have cloud account**
-- MAGIC
-- MAGIC #### Steps:
-- MAGIC - Create role with describe, read and write permission in the policy
-- MAGIC - Provide cross account access using Trustrelation
-- MAGIC - Followed by running the following script
-- MAGIC
-- MAGIC _CREATE STORAGE CREDENTIAL s3_iam_role_cred
-- MAGIC WITH IAM_ROLE 'arn:aws:iam::123456789012:role/DatabricksS3AccessRole'
-- MAGIC COMMENT 'Credential for accessing S3 via IAM role';_
-- MAGIC
-- MAGIC _CREATE EXTERNAL LOCATION CAPSTONE_BRONZE_RAW
-- MAGIC URL 's3://CAPSTONE/'
-- MAGIC WITH STORAGE CREDENTIAL s3_iam_role_cred
-- MAGIC COMMENT 'CAPSTONE data stored in S3';_

-- COMMAND ----------

CREATE VOLUME IF NOT EXISTS CAPSTONE.BRONZE.RAW;

-- COMMAND ----------

-- MAGIC %python
-- MAGIC
-- MAGIC import os
-- MAGIC
-- MAGIC base_raw_path = "/Volumes/CAPSTONE/bronze/raw/files/landing"               # root landing zone
-- MAGIC transactions_path = f"{base_raw_path}/transactions_raw"
-- MAGIC customers_path = f"{base_raw_path}/customers_raw"
-- MAGIC products_path = f"{base_raw_path}/products_raw"
-- MAGIC
-- MAGIC dbutils.fs.mkdirs(base_raw_path)
-- MAGIC dbutils.fs.mkdirs("/Volumes/CAPSTONE/bronze/raw/files/checkpoint")
-- MAGIC dbutils.fs.mkdirs("/Volumes/CAPSTONE/bronze/raw/files/schema")
-- MAGIC dbutils.fs.mkdirs(transactions_path)
-- MAGIC dbutils.fs.mkdirs(customers_path)
-- MAGIC dbutils.fs.mkdirs(products_path)
-- MAGIC
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Uploading Files:
-- MAGIC
-- MAGIC Files are uploaded to user folder. They are then copied to the volume.

-- COMMAND ----------

-- MAGIC %python
-- MAGIC dbutils.fs.cp(f"{os.getcwd()}/products_raw.csv",products_path)
-- MAGIC dbutils.fs.cp(f"{os.getcwd()}/customer_raw.csv",customers_path)
-- MAGIC dbutils.fs.cp(f"{os.getcwd()}/transaction_raw.csv",transactions_path)

-- COMMAND ----------

-- MAGIC %skip
-- MAGIC %python
-- MAGIC dbutils.fs.cp(f"{os.getcwd()}/products_raw.csv",products_path + "/products_raw1.csv")

-- COMMAND ----------

-- MAGIC %sh
-- MAGIC ls -lrt /Volumes/CAPSTONE/bronze/raw/files/landing/*/
-- MAGIC
