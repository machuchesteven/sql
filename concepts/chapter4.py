from faker import Faker
fake = Faker()
def fake_address():
    address = fake.address()
    address = address.replace("\n", " ")
    return address
def fake_city():
    return fake.city()
def fake_country():
    return fake.country()

def add_addresses():
    with open("names.sql", "w") as f:
        for i in range(0, 100):
            f.write(f"INSERT INTO addresses (address_id, street_address, city, st, country) VALUES ({i+1}, '{fake_address()}', '{fake_city()}', '{fake_city()[:2].upper()}', '{fake_country()}');\n")
        print("Names Created:")
        f.close()
    return
# add_addresses()


def add_projects():
    with open ("projects.sql", "w") as f:
        for i in range(0, 100):
            f.write(f"INSERT INTO projects (project_id, project_name, project_cost, days) VALUES ({i+1}, '{fake.company()}', {fake.random.randint(4, 13000)}, {fake.random.randint(1,10)} );\n")
        print("Projects Created:")
        f.close()
    return

add_projects()