
import faker
import random
import pandas as pd
import numpy as np
import uuid
import csv
from datetime import date
from math import ceil

def fake_leads():
    from faker import Faker

    headers = ["ID",
        "Quote_product_id",
        "quote_price",
        "quote_value",
        "sale_flag",
        "order_id",
        "customer_id",
        "company_id",
        "created_date"]
    fake = Faker()
    with open('leads.csv', 'w+', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(headers)
        for i in range(1,10000):
            lead_id = uuid.uuid1()
            product_id = random.randint(1000,11000)
            quote_price = random.randint(1,500)
            quote_value = random.randint(10,50)
            sale_flag = fake.boolean()

            order_id = fake.bothify(text='????-########', letters='ABCDEFGHIJKLMNOPQRSTUVWXYZ') if sale_flag else None
            customer_id = random.randint(1000,11000) if sale_flag else None
            company_id = random.randint(1,1000)
            created_date = fake.date_between(date(2021, 5, 31))


            writer.writerow([lead_id, product_id, quote_price,\
                             quote_value, sale_flag, order_id, customer_id,\
                             company_id,created_date])

def read_country_code_csv(seed_length):
    data = pd.read_csv("/usr/local/airflow/include/dataset/wikipedia-iso-country-codes.csv")
    df = data[['Country','Alpha-2 code']].head(seed_length)
    df.to_csv('country_codes.csv', index=False, header=False)
    return df['Alpha-2 code'].tolist()


def generate():
    fake = faker.Faker('en_IN')

    ## columns
    # company = ['company_id','company_name','is_supplier','country_code']
    # company_products=['id','company_id','product_id']
    # country_codes=['code','country_name','start_ip','end_ip']
    # customers=['customer_id','f_name','l_name','dob','created_at','email','user_name','country_code']
    # invoice=['invoice_id','buyer_id','seller_id','amount']
    # order_line_item=['id','order_id','invoice_id','product_id','no_of_items','final_amount','created_at','updated_at']
    # orders=['order_id','invoice_id','payment_status','delivery_status']
    # products=['product_id','product_name','price','created_at','updated_at']
    # suppliers=['supplier_id','supplier_name','supplier_reg_address','supplier_email','supplier_phone_numer','country_code']
    # supplier_products=['id','supplier_id','product_id']

    #country_code
    num=10
    c_codes=read_country_code_csv(20)
    
    #company
    num = 10
    company_data=[{
        'company_id': f"COM{x:0>{3}}",
        'company_name': fake.company() +" "+ fake.company_suffix() ,
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
        'created_at':fake.past_datetime(start_date='-800d'),
        'email':fake.ascii_safe_email(),
        'user_name':fake.user_name(),
        'country_code':np.random.choice(c_codes)
    } for x in range(1,num+1)]
    custo_df = pd.DataFrame(custo_data)
    # df.to_csv('customer.csv')

    #supplier
    num=10    
    faker.Faker.seed(0)
    supp_data=[{
        'supplier_id':f"SUP{x:0>{3}}",
        'supplier_name': fake.company() +" "+ fake.company_suffix(),
        'supplier_reg_address': fake.address(),
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
    prod_data = prod_data + [{
        'product_id': v[0],
        'product_name':v[1],
        'price':v[2],
        'created_at':fake.past_datetime(start_date='-800d'),
        'updated_at':fake.past_datetime(start_date='-800d')
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
        'created_at':fake.past_datetime(start_date='-800d'),
        'updated_at':fake.past_datetime(start_date='-800d')
    } for k, v in enumerate(s_assigned_plist)]

    #assign supplier and company products
    for k,v in enumerate(cs_assigned_plist):
        #add supplier variant
        prod_data = prod_data + [{
            'product_id': f"PROD{len(prod_data)+1:0>{3}}",
            'product_name':v[1],
            'price':v[2],
            'created_at':fake.past_datetime(start_date='-800d'),
            'updated_at':fake.past_datetime(start_date='-800d')
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
            'created_at':fake.past_datetime(start_date='-800d'),
            'updated_at':fake.past_datetime(start_date='-800d')
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


def generate_orders(no_of_orders=10):
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


    custo_df = pd.read_csv('customers.csv',names=customers)
    custo_df = custo_df['customer_id'].tolist()

    supp_df = pd.read_csv('suppliers.csv', names=suppliers)
    sp_df=pd.read_csv('supplier_products.csv', names=supplier_products)
    supp_df = pd.merge(sp_df,supp_df[['supplier_id','country_code']],how='left',on=['supplier_id']) #cols=[supplier_id,product_id,unit_price,country_code]

    comp_df = pd.read_csv('company.csv', names=company)
    cp_df=pd.read_csv('company_products.csv', names=company_products)
    comp_df = pd.merge(cp_df,comp_df,how='left',on=['company_id']) # cols =[company_id,product_id,unit_price,company_name,is_supplier,country_code]


    prod_df=pd.read_csv('products.csv', names=products)

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
    for i in range(1,ceil(no_of_orders/3)+1):

        # CASE: custoXcompany

        faker.Faker.seed(0)
        invoice_id = uuid.uuid1()
        order_id = uuid.uuid1()

        #select random customer -> randomw companyand product -> random no of items -> cal amount
        s_customer = random.sample(custo_df,1)[0]
        s_comp_prod = (comp_df.sample(n=1)).to_dict('records')[0]
        s_items = random.sample([i for i in range(1,21)],1)[0]

        # populate line item
        oli_list=oli_list + [{
            'id': len(oli_list)+1,
            'order_id': order_id,
            'invoice_id': invoice_id,
            'product_id':s_comp_prod["product_id"],
            'no_of_items': s_items,
            'final_amount': s_items*s_comp_prod["unit_price"],
            'created_at': fake.past_datetime(start_date='-800d'),
            'updated_at': fake.past_datetime(start_date='-800d')
        }]
        #populate orders
        order_list = order_list + [{
            'order_id': order_id,
            'invoice_id': invoice_id,
            'payment_status': random.choice(['PENDING','APPROVED','CANCELLED']),
            'delivery_status': random.choice(['PENDING','COMPLETED','CANCELLED'])
        }]
        #populate invoice
        invoice_list = invoice_list + [{
            'invoice_id': invoice_id,
            'buyer_id': s_customer,
            'seller_id': s_comp_prod['company_id'],
            'amount': s_items*s_comp_prod["unit_price"] # only 1 item in the order=> final amt is amt
        }]

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
            'id': len(oli_list)+1,
            'order_id': order_id,
            'invoice_id': invoice_id,
            'product_id':s_supp_prod["product_id"],
            'no_of_items': s_items,
            'final_amount': s_items*s_supp_prod["unit_price"],
            'created_at': fake.past_datetime(start_date='-800d'),
            'updated_at': fake.past_datetime(start_date='-800d')
        }]
        #populate orders
        order_list = order_list + [{
            'order_id': order_id,
            'invoice_id': invoice_id,
            'payment_status': random.choice(['PENDING','APPROVED','CANCELLED']),
            'delivery_status': random.choice(['PENDING','COMPLETED','CANCELLED'])
        }]
        #populate invoice
        invoice_list = invoice_list + [{
            'invoice_id': invoice_id,
            'buyer_id': s_company,
            'seller_id': s_supp_prod['supplier_id'],
            'amount': s_items*s_supp_prod["unit_price"] # only 1 item in the order=> final amt is amt
        }]


    for i in range(1,ceil(no_of_orders/3)+1):

        # CASE:companyXcompany
        faker.Faker.seed(0)
        invoice_id = uuid.uuid1()
        order_id = uuid.uuid1()

        #select random company -> randomw company)supplier and product -> random no of items -> cal amount
        s_company = random.sample(comp_df['company_id'].tolist(),1)[0]   
        s_comp_prod = ((comp_df[(comp_df['is_supplier']==1)]).sample(n=1)).to_dict('records')[0]
        s_items = random.sample([i for i in range(1,21)],1)[0]
        if s_comp_prod['company_id']==s_company:
            continue
        else:
            oli_list = oli_list + [{
                'id': len(oli_list)+1,
                'order_id': order_id,
                'invoice_id': invoice_id,
                'product_id':s_comp_prod["product_id"],
                'no_of_items': s_items,
                'final_amount': s_items*s_comp_prod["unit_price"],
                'created_at': fake.past_datetime(start_date='-800d'),
                'updated_at': fake.past_datetime(start_date='-800d')
            }]  
        #populate orders
        order_list = order_list + [{
            'order_id': order_id,
            'invoice_id': invoice_id,
            'payment_status': random.choice(['PENDING','APPROVED','CANCELLED']),
            'delivery_status': random.choice(['PENDING','COMPLETED','CANCELLED'])
        }]
        #populate invoice
        invoice_list = invoice_list + [{
            'invoice_id': invoice_id,
            'buyer_id': s_company,
            'seller_id': s_comp_prod['company_id'],
            'amount': s_items*s_comp_prod["unit_price"] # only 1 item in the order=> final amt is amt
        }]                  

    oli_df = pd.DataFrame(oli_list)
    oli_df.to_csv('order_line_item.csv',index=False,header=False)
    order_df = pd.DataFrame(order_list)
    order_df.to_csv('orders.csv',header=False, index=False)
    invoice_df = pd.DataFrame(invoice_list)
    invoice_df.to_csv('invoice.csv',header=False,index=False)
