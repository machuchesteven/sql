
import random
import datetime

# function to generate fake data
def generate_fake_data(count):
    fake_data = []
    for i in range(count):
        name = "Client " + str(i+1)
        date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        price = round(random.uniform(10, 100), 2)
        fake_data.append((name, date, price))
    return fake_data

# function to write fake data to sql file
def write_to_sql_file(fake_data):
    with open("clients.sql", "w") as f:
        for data in fake_data:
            f.write(f"INSERT INTO clients (name, date, price) VALUES ('{data[0]}', '{data[1]}', {data[2]});\n")

# main function to generate fake data and write to sql file
def main(count):
    fake_data = generate_fake_data(count)
    write_to_sql_file(fake_data)

# example usage
main(100)
