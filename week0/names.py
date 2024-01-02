# this helps in learning importing and exporting data to postgresql
from faker import Faker

fake = Faker()

def fake_first_name():
    name = fake.first_name()
    return name

def fake_last_name():
    return fake.last_name_male()


def add_names():
    with open("names.sql", "w") as f:
        for i in range(0, 100):
            f.write(f"insert into names (first_name, last_name) values ('{fake_first_name()}', '{fake_last_name()}');\n")
        print("Names Created:")
        f.close()


# COPY names TO 'C:\Users\julie\Desktop\Machuche\progress\sql\week0\names.txt' WITH (FORMAT CSV, HEADER, DELIMITER '|');


add_names()