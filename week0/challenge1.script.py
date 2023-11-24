
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
def write_to_sql_file(filename, fake_data):
    with open(f"{filename}.sql", "w") as f:
        for data in fake_data:
            f.write(f"INSERT INTO {filename} (name, date, price) VALUES ('{data[0]}', '{data[1]}', {data[2]});\n")


def main(count):
    # filename to insert the table into
    print("Welcome to the table generator!\nYou are supposed to enter the filename to insert the table into.\nThe filename should be a table name of your table.\n")
    filename = input("Enter the filename to insert the table into:")
    if filename == "exit":
        pass
    fake_data = generate_fake_data(count)
    write_to_sql_file(filename=filename, fake_data=fake_data)

# example usage
main(100)
