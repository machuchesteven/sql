#  here covers storytelling with data

# insert into product (name, price, quantity) values ('Mayonaise', 24000.0008, 200);

# default date column in postgresql
from faker import Faker
# creating fake ecommerce names and tools
# import faker_commerce

f = Faker()
# f.add_provider(faker_commerce.Provider)

# add ecommerce_name
# add ecommerce_category
# add ecommerce_price


def create_products_data(rows_num:int):
    with open('products.sql', 'w+') as table:
        for i in range(rows_num):
            table.write(f"INSERT INTO product (name, price, quantity) VALUES ('{f.name()}', {float(f.pricetag()[1:].replace(',', ''))}, {f.random_int()});\n")
        table.close()
    print("It is done!")
create_products_data(100)
