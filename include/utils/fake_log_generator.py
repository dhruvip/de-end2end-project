import time
import datetime
import pytz
import numpy
import random
import gzip
import zipfile
import sys
import argparse
from faker import Faker
from random import randrange
from tzlocal import get_localzone
local = get_localzone()


def generate_user_journey(prod_ids, uname, uagent):
    resources=["/auth","/orders","/checkout","/add-to-cart","/products?search=","/users","/login"]
    if isinstance(prod_ids, str):
        resources = resources + [f"/product-detail/{prod_ids}"]
    else:
        resources = resources + [f"/product-detail/{id}" for id in prod_ids]


    log_lines = 50
    sleep=0.0

    faker = Faker()

    timestr = time.strftime("%Y%m%d-%H%M%S")
    otime = datetime.datetime.now()

    outFileName = 'access_log_'+timestr+'.log'


    f = open("/tmp/logs/"+outFileName,'w')

    response=["200","404","500","301"]

    verb=['GET']


    flag = True
    while (flag):
        if sleep:
            increment = datetime.timedelta(seconds=sleep)
        else:
            increment = datetime.timedelta(seconds=random.randint(30, 300))
        otime += increment

        ip = faker.ipv4()
        dt = otime.strftime('%d/%b/%Y:%H:%M:%S')
        tz = datetime.datetime.now(local).strftime('%z')
        vrb = verb[0]

        uri = random.choice(resources)
        if uri.find("apps")>0:
            uri += str(random.randint(1000,10000))

        resp = numpy.random.choice(response,p=[0.9,0.04,0.02,0.04])
        byt = int(random.gauss(5000,50))
        f.write(f"{ip} - {uname} {dt} '{vrb} HTTP/1.0' {resp} {byt} {uri} {uagent}\n")
        f.flush()

        log_lines = log_lines - 1
        flag = False if log_lines == 0 else True
        if sleep:
            time.sleep(sleep)
    f.close()
    