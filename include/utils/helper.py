from airflow.models import Variable
from airflow.providers.amazon.aws.hooks.s3 import S3Hook
import os
from tempfile import NamedTemporaryFile
from pandas import DataFrame
from datetime import date

def copy_csv_to_s3_bulk(aws_conn_id, source_dir, dest_bucket, dest_key, replace=True, file_ext='csv',delete_on_success=False):
    s3_hook = S3Hook(aws_conn_id=aws_conn_id)
    files = [(os.path.join(source_dir, f),f) for f in os.listdir(source_dir) if f.find(f".{file_ext}") != -1]
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
        if delete_on_success:
            os.remove(filename)

def process_logs_to_csv_s3(aws_conn_id, source_dir, dest_bucket, dest_key, replace=True, file_ext='csv',delete_on_success=False):
    files = [(os.path.join(source_dir, f),f) for f in os.listdir(source_dir) if f.find(f".{file_ext}") != -1]
    csv_lines=[]
    for _each_file in files:
        with open(_each_file[0]) as f:
            lines = [line.rstrip() for line in f]
            
            for line in lines:
                line=line.strip()
                # 104.15.222.194 - lgola 21/Aug/2023:07:48:15 'GET HTTP/1.0' 200 4966 /auth iPad; CPU iPad OS 9_3_6 like Mac OS X
                v_req="'GET HTTP/1.0'"
                [l1, l2] = line.split(v_req)
                
                # 104.15.222.194 - lgola 21/Aug/2023:07:48:15 
                [v_ip, v_itend, v_uname, v_tstamp, z] = l1.split(" ")

                [l3, l4] = l2.split("/",1)

                # ['', '200', '4966', '']
                [x,v_scode, v_bytes, y] = l3.split(" ")

                [v_refr,v_uagent]=l4.split(" ",1)
                v_refr= "/" + v_refr
                v_uagent = v_uagent.strip()

                csv_lines.append({
                    "ip": v_ip.strip(),
                    "u_ident": v_itend.strip(),
                    "username": v_uname.strip(),
                    "tstamp": v_tstamp.strip(),
                    "req": v_req.strip(),
                    "statuscode": v_scode.strip(),
                    "bytes": v_bytes.strip(),
                    "refr_path": v_refr.strip(),
                    "uagent": f"'{v_uagent.strip()}'"
                })
        df = DataFrame(csv_lines)
    df.to_csv('/tmp/logs/combined_logs.csv', index=False, header=False)




            
def convert_leads_to_csv_s3(aws_conn_id, source, target, dest_bucket, csv_header):
    s3_hook = S3Hook(aws_conn_id=aws_conn_id)
    s3_obj = s3_hook.get_key(key=source)

    with NamedTemporaryFile() as local_tmp_file:
        print("Downloading file from " + source)
        s3_obj.download_fileobj(local_tmp_file)
        local_tmp_file.seek(0)
        from pandas import read_excel
        df = read_excel(local_tmp_file.name,index_col=0)
        fname = NamedTemporaryFile()
        df.to_csv(fname,index=False,header=csv_header)
        s3_hook.load_file(
            fname.name,
            target,
            replace=True
        )
        print("File stored in" + target)
        