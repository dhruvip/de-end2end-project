
import signal
from time import sleep
import faker
import random
import pandas as pd
import numpy as np
import uuid
import csv
from datetime import date
from math import ceil
import re
from include.utils.fake_log_generator import generate_user_journey

## Column details
company = ['company_id','company_name','is_supplier','country_code']
company_products=['id','company_id','product_id','unit_price']
country_codes=['code','country_name','start_ip','end_ip']
customers=['customer_id','f_name','l_name','dob','created_at','email','user_name','country_code']
invoice=['invoice_id','buyer_id','seller_id','amount']
order_line_item=['id','order_id','invoice_id','product_id','no_of_items','final_amount','created_at','updated_at']
orders=['order_id','invoice_id','payment_status','delivery_status']
products=['product_id','product_name','price','created_at','updated_at']
suppliers=['supplier_id','supplier_name','supplier_reg_address','supplier_email','supplier_phone_numer','country_code']
supplier_products=['id','supplier_id','product_id','unit_price']


def generate_fake_leads(no_of_leads=20):
    """
    Note: this should run after appdb is popultaed
    """
    custo_df=pd.read_csv("customers.csv", names=customers)
    orders_df = pd.read_csv('orders.csv',names=orders)
    invoice_df = pd.read_csv("invoice.csv", names=invoice)
    oli_df = pd.read_csv("order_line_item.csv",names=order_line_item)
    final_df = pd.merge(oli_df, invoice_df, how='left', on=['invoice_id'])
    final_df = pd.merge(final_df,orders_df,how='left', on=['order_id'])
    # final_df['created_at'] = pd.to_datetime(final_df['created_at'])
    final_df=final_df[final_df.buyer_id.str.startswith('CUS')]
    final_df = pd.merge(final_df,custo_df, how='left', left_on='buyer_id', right_on='customer_id',suffixes=['_1','_2'])
    
    final_df.rename(columns={'created_at_1': 'order_created_at','created_at_2':'created_at'},inplace=True)
    final_df.sort_values(by='order_created_at', inplace=True, ascending=False)
    
    # get customers who ordered
    custo_orders = (final_df.head(ceil(no_of_leads/2)))[['customer_id','product_id','order_id','order_created_at','user_name','created_at','country_code']]
    
    custo_orders_list=list(custo_orders.itertuples(name='Row', index=False))
    fake = faker.Faker()
    faker.Faker.seed(0)
    ualist = [fake.chrome() for i in range(10)] + [fake.android_platform_token() for i in range(10)] + [fake.ios_platform_token() for i in range(10)]
    for _e in custo_orders_list:
        useragent = np.random.choice(ualist)
        generate_user_journey(_e.product_id,_e.user_name,useragent)
        sleep(5)

    
    # customers who didnt order
    remain_custo = set(custo_df['user_name'].values.tolist()) - set(custo_orders['user_name'].values.tolist())
    remain_prod = set(oli_df['product_id'].values.tolist()) - set(custo_orders['product_id'].values.tolist())
    for _e in remain_custo:
        useragent = np.random.choice(ualist)
        generate_user_journey(np.random.choice(list(remain_prod),5),_e,useragent)
        sleep(2)
    
    #generate leads file
    ## for users with order_id
    ## for customers with out order id
    campaign_channels = ['Facebook','Instagram','Organic','Paid Search','Google Ads','Offline']
    leads_list = [{
        "lead_id": uuid.uuid1(),
        "uname":_e.user_name,
        "first_contact_date":fake.past_datetime(start_date='-1d'),
        "campaign_channel": np.random.choice(campaign_channels,1)[0],
        "campaign_name":"",
        "order_id":_e.order_id,
        "product_id": _e.product_id
    } for _e in custo_orders_list]
    leads_list = leads_list + [{
        "lead_id": uuid.uuid1(),
        "uname":_uname,
        "first_contact_date":fake.past_datetime(start_date='-1d'),
        "campaign_channel": np.random.choice(campaign_channels,1)[0],
        "campaign_name":"",
        "order_id":None,
        "product_id": _y
    } for _y in remain_prod for _uname in remain_custo]
    leads_df = pd.DataFrame(leads_list)
    leads_df.to_excel(f"/tmp/leads/marketing_sales_leads.xlsx")
    # leads_df.to_csv(f"/tmp/leads/marketing_sales_leads.csv")


def read_country_code_csv(seed_length):
    data = pd.read_csv("/usr/local/airflow/include/dataset/wikipedia-iso-country-codes.csv")
    df = data[['Country','Alpha-2 code']].head(seed_length)
    df.to_csv('country_codes.csv', index=False, header=False)
    return df['Alpha-2 code'].tolist()


def generate(since_days='-800d'):
    fake = faker.Faker('en_IN')

    #country_code
    num=10
    c_codes=read_country_code_csv(20)
    
    #company
    num = 10
    company_data=[{
        'company_id': f"COM{x:0>{3}}",
        'company_name': re.sub(",","-",fake.company() +" "+ fake.company_suffix()) ,
        'is_supplier': random.sample([0]*8+[1]*2,1)[0],
        'country_code': np.random.choice(c_codes)
    } for x in range(1,num+1)]
    comp_df = pd.DataFrame(company_data)
    # df.to_csv('company.csv')

    #customer
    num=10
    faker.Faker.seed(0)
    custo_data=[{
        'customer_id':f"CUST{x:0>{3}}",
        'f_name':fake.first_name(),
        'l_name':fake.last_name(),
        'dob':fake.date_of_birth(),
        'created_at':fake.past_datetime(start_date=since_days),
        'email':fake.ascii_safe_email(),
        'user_name':fake.unique.user_name(),
        'country_code':np.random.choice(c_codes)
    } for x in range(1,num+1)]
    custo_df = pd.DataFrame(custo_data)
    # df.to_csv('customer.csv')

    #supplier
    num=10    
    faker.Faker.seed(0)
    supp_data=[{
        'supplier_id':f"SUP{x:0>{3}}",
        'supplier_name': re.sub(",","-",fake.company() +" "+ fake.company_suffix()),
        'supplier_reg_address': re.sub(",","-",re.sub(r'\n'," ",fake.address())),
        'supplier_email':fake.ascii_safe_email(),
        'supplier_phone_numer':fake.phone_number(),
        'country_code':np.random.choice(c_codes)
    } for x in range(1,num+1)]
    supp_df = pd.DataFrame(supp_data)
    # df.to_csv('supplier.csv')
    
    
    #productXcompany ; productXsupplier relations
    no_of_company = len(comp_df.index)
    no_of_suppliers = len(supp_df.index)
    no_of_cs = len(comp_df[(comp_df['is_supplier']==1)].index)
    req_no_of_products = 5*no_of_company + 5*no_of_suppliers + no_of_cs

    #products
    prod_meta_df=pd.read_csv('./include/dataset/products_meta.csv')
    prod_list = prod_meta_df[['Description','UnitPrice']].head(req_no_of_products).values.tolist()
    prod_list = [[f"PROD{i+1:0>{3}}"]+x for i,x in enumerate(prod_list)]
    del prod_meta_df

    #assign products to company and suppliers
    c_assigned_plist=prod_list[:5*no_of_company]
    s_assigned_plist=prod_list[5*no_of_company:5*no_of_company+5*no_of_suppliers]
    cs_assigned_plist=prod_list[5*no_of_company+5*no_of_suppliers:]

    # assign products to company
    cp_df=[{
    'id':i+1,
    'company_id': f"COM{np.random.choice([i for i in range(1,11)]):0>{3}}",
    'product_id':x[0],
    'unit_price':x[2]
    } for i, x in enumerate(c_assigned_plist)]
    
    #add company products to products
    prod_data=[]
    faker.Faker.seed(0)
    prod_data = prod_data + [{
        'product_id': v[0],
        'product_name':v[1],
        'price':v[2],
        'created_at':fake.past_datetime(start_date=since_days),
        'updated_at':fake.past_datetime(start_date=since_days)
    } for k, v in enumerate(c_assigned_plist)]

    #assign supplier products
    sp_df = [{
    'id':i+1,
    'supplier_id': f"SUP{np.random.choice([i for i in range(1,11)]):0>{3}}",
    'product_id':x[0],
    'unit_price': x[2]
    } for i, x in enumerate(s_assigned_plist)]
    
    #add supplier products to products
    p_len=len(prod_data)
    prod_data = prod_data + [{
        'product_id': v[0],
        'product_name':v[1],
        'price':v[2],
        'created_at':fake.past_datetime(start_date=since_days),
        'updated_at':fake.past_datetime(start_date=since_days)
    } for k, v in enumerate(s_assigned_plist)]

    #assign supplier and company products
    for k,v in enumerate(cs_assigned_plist):
        #add supplier variant
        prod_data = prod_data + [{
            'product_id': f"PROD{len(prod_data)+1:0>{3}}",
            'product_name':v[1],
            'price':v[2],
            'created_at':fake.past_datetime(start_date=since_days),
            'updated_at':fake.past_datetime(start_date=since_days)
        }]
        sp_df = sp_df + [{
            'id':len(sp_df)+1,
            'supplier_id': f"SUP{np.random.choice([i for i in range(1,11)]):0>{3}}",
            'product_id': f"PROD{len(prod_data):0>{3}}",
            'unit_price': v[2]
        }]
        # add company variant

        prod_data = prod_data + [{
            'product_id': f"PROD{len(prod_data)+1:0>{3}}",
            'product_name':v[1],
            'price':v[2]*2,
            'created_at':fake.past_datetime(start_date=since_days),
            'updated_at':fake.past_datetime(start_date=since_days)
        }]
        cp_df= cp_df + [{
            'id':len(cp_df)+1,
            'company_id': f"COM{np.random.choice([i for i in range(1,11)]):0>{3}}",
            'product_id':f"PROD{len(prod_data):0>{3}}",
            'unit_price': v[2]*2
        }]

    comp_df.to_csv('company.csv', index=False, header=False)
    custo_df.to_csv('customers.csv', index=False, header=False)
    supp_df.to_csv('suppliers.csv', index=False, header=False)

    df = pd.DataFrame(sp_df)
    df.to_csv('supplier_products.csv', index=False, header=False)

    df = pd.DataFrame(cp_df)
    df.to_csv('company_products.csv', index=False, header=False)

    df= pd.DataFrame(prod_data)
    df.to_csv('products.csv',index=False, header=False)
    generate_orders(10)


def generate_orders(no_of_orders=5000, req_header=False, since_days='-800d'):

    custo_df = pd.read_csv('customers.csv',names=customers)
    custo_df = custo_df['customer_id'].tolist()

    supp_df = pd.read_csv('suppliers.csv', names=suppliers)
    sp_df=pd.read_csv('supplier_products.csv', names=supplier_products)
    supp_df = pd.merge(sp_df,supp_df[['supplier_id','country_code']],how='left',on=['supplier_id']) #cols=[supplier_id,product_id,unit_price,country_code]

    comp_df = pd.read_csv('company.csv', names=company)
    cp_df=pd.read_csv('company_products.csv', names=company_products)
    comp_df = pd.merge(cp_df,comp_df,how='left',on=['company_id']) # cols =[company_id,product_id,unit_price,company_name,is_supplier,country_code]


    # prod_df=pd.read_csv('products.csv', names=products)

    ## Column details
    # invoice=['invoice_id','buyer_id','seller_id','amount']
    # order_line_item=['id','order_id','invoice_id','product_id','no_of_items','final_amount','created_at','updated_at']
    # orders=['order_id','invoice_id','payment_status','delivery_status']


    #select invoice id, order_id->buyer, seller->
    # products_id, no_of_ites, -> final_amt -> insert OLI
    # -> insert invoice -> insert order
    fake = faker.Faker('en_IN')
    oli_list = []
    order_list=[]
    invoice_list=[]
    faker.Faker.seed(0)

    for i in range(1,ceil(no_of_orders/3)+1):

        # CASE: custoXcompany

        invoice_id = uuid.uuid1()
        order_id = uuid.uuid1()

        #select random customer -> randomw companyand product -> random no of items -> cal amount
        s_customer = random.sample(custo_df,1)[0]
        s_comp_prod = (comp_df.sample(n=1)).to_dict('records')[0]
        s_items = random.sample([i for i in range(1,21)],1)[0]

        # populate line item
        oli_list=oli_list + [{
            'id': order_id,
            'order_id': order_id,
            'invoice_id': invoice_id,
            'product_id':s_comp_prod["product_id"],
            'no_of_items': s_items,
            'final_amount': s_items*s_comp_prod["unit_price"],
            'created_at': fake.unique.past_datetime(start_date=since_days),
            'updated_at': fake.unique.past_datetime(start_date=since_days)
        }]
        #populate orders
        order_list = order_list + [{
            'order_id': order_id,
            'invoice_id': invoice_id,
            'payment_status': np.random.choice(['PENDING','APPROVED','CANCELLED'],p=[0.3,0.5,0.2]),
            'delivery_status': np.random.choice(['PENDING','COMPLETED','CANCELLED'],p=[0.3,0.5,0.2])
        }]
        #populate invoice
        invoice_list = invoice_list + [{
            'invoice_id': invoice_id,
            'buyer_id': s_customer,
            'seller_id': s_comp_prod['company_id'],
            'amount': s_items*s_comp_prod["unit_price"] # only 1 item in the order=> final amt is amt
        }]
    faker.Faker.seed(0)

    for i in range(1,ceil(no_of_orders/3)+1):

        # CASE: companyXsupplier
        faker.Faker.seed(0)
        invoice_id = uuid.uuid1()
        order_id = uuid.uuid1()

        #select random company -> randomw supplierand product -> random no of items -> cal amount
        s_company = random.sample(comp_df['company_id'].tolist(),1)[0]   
        s_supp_prod = (supp_df.sample(n=1)).to_dict('records')[0]
        s_items = random.sample([i for i in range(1,21)],1)[0]

        oli_list = oli_list + [{
            'id': order_id,
            'order_id': order_id,
            'invoice_id': invoice_id,
            'product_id':s_supp_prod["product_id"],
            'no_of_items': s_items,
            'final_amount': s_items*s_supp_prod["unit_price"],
            'created_at': fake.unique.past_datetime(start_date=since_days),
            'updated_at': fake.unique.past_datetime(start_date=since_days)
        }]
        #populate orders
        order_list = order_list + [{
            'order_id': order_id,
            'invoice_id': invoice_id,
            'payment_status': np.random.choice(['PENDING','APPROVED','CANCELLED'],p=[0.3,0.5,0.2]),
            'delivery_status': np.random.choice(['PENDING','COMPLETED','CANCELLED'],p=[0.3,0.5,0.2])
        }]
        #populate invoice
        invoice_list = invoice_list + [{
            'invoice_id': invoice_id,
            'buyer_id': s_company,
            'seller_id': s_supp_prod['supplier_id'],
            'amount': s_items*s_supp_prod["unit_price"] # only 1 item in the order=> final amt is amt
        }]


    faker.Faker.seed(0)
    for i in range(1,ceil(no_of_orders/3)+1):

        # CASE:companyXcompany
        faker.Faker.seed(0)
        invoice_id = uuid.uuid1()
        order_id = uuid.uuid1()

        #select random company -> randomw company)supplier and product -> random no of items -> cal amount
        s_company = random.sample(comp_df['company_id'].tolist(),1)[0]   
        s_comp_prod = ((comp_df[(comp_df['is_supplier']=="t")]).sample(n=1)).to_dict('records')[0]
        s_items = random.sample([i for i in range(1,21)],1)[0]
        if s_comp_prod['company_id']==s_company:
            continue
        else:
            oli_list = oli_list + [{
                'id': order_id,
                'order_id': order_id,
                'invoice_id': invoice_id,
                'product_id':s_comp_prod["product_id"],
                'no_of_items': s_items,
                'final_amount': s_items*s_comp_prod["unit_price"],
                'created_at': fake.unique.past_datetime(start_date=since_days),
                'updated_at': fake.unique.past_datetime(start_date=since_days)
            }]  
        #populate orders
        order_list = order_list + [{
            'order_id': order_id,
            'invoice_id': invoice_id,
            'payment_status': np.random.choice(['PENDING','APPROVED','CANCELLED'],p=[0.3,0.5,0.2]),
            'delivery_status': np.random.choice(['PENDING','COMPLETED','CANCELLED'],p=[0.3,0.5,0.2])
        }]
        #populate invoice
        invoice_list = invoice_list + [{
            'invoice_id': invoice_id,
            'buyer_id': s_company,
            'seller_id': s_comp_prod['company_id'],
            'amount': s_items*s_comp_prod["unit_price"] # only 1 item in the order=> final amt is amt
        }]                  

    oli_df = pd.DataFrame(oli_list)
    oli_df.to_csv('order_line_item.csv',index=False,header=req_header)
    order_df = pd.DataFrame(order_list)
    order_df.to_csv('orders.csv',header=req_header, index=False)
    invoice_df = pd.DataFrame(invoice_list)
    invoice_df.to_csv('invoice.csv',header=req_header,index=False)


def generate_insert_queries(dbname="b2bdb",list_of_tables=["orders","order_line_item","invoice"],fname="order_insert_queries.sql"):
    final_insert_stmt=""
    for table in list_of_tables:
        df=pd.read_csv(f"{table}.csv")
        headers = tuple(df.columns.tolist())
        # df_list = df.to_dict('records')
        df_list = list(df.itertuples(name='Row', index=False))
        vtuples_list=[]
        for _each in df_list:
            temp_tuple=tuple()
            for col in headers:
                temp_tuple = temp_tuple + tuple([_each.__getattribute__(col)])
            vtuples_list.append(temp_tuple.__str__())
        values_str = ",".join(vtuples_list)
        insert_stmt=f"INSERT INTO {table} VALUES {values_str}; "
        final_insert_stmt = final_insert_stmt + insert_stmt
    with open(fname, "w") as f:
        f.writelines(final_insert_stmt)
            


