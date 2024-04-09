from faker import Faker

fake = Faker()


def generate():
    with open("test.sql", "w") as f:
        for i in range(100):
            f.write(f"INSERT INTO subscribers (first_name, last_name) VALUES ('{fake.first_name()}', '{fake.last_name()}');\n")
    print("Generating online values")


generate()