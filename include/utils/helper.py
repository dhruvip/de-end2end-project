from airflow.models import Variable
from airflow.providers.amazon.aws.hooks.s3 import S3Hook
import os
import re

def copy_csv_to_s3_bulk(aws_conn_id, source_dir, dest_bucket, dest_key, replace=True):
    s3_hook = S3Hook(aws_conn_id=aws_conn_id)
    files = [(os.path.join(source_dir, f),f) for f in os.listdir(source_dir) if re.match(r'.*\.(csv)', f)]
    for _each in files:
        filename = _each[0]
        s3_bucket, s3_key = s3_hook.get_s3_bucket_key(
            dest_bucket, dest_key+_each[1], "dest_bucket", "dest_key"
        )
        s3_hook.load_file(
            filename,
            s3_key,
            s3_bucket,
            replace
        )