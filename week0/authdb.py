from faker import Faker


fake = Faker()
# create table people (
# id int primary key identity, 
# name varchar(50) unique, 
# email varchar(50) not null, 
# [address] varchar(200) not null);

def main():
    with open("people.sql", "w") as f:
        for i in range(100):
            name = fake.name()
            email = fake.email()
            address = fake.address()
            f.write(f"INSERT INTO [dbo].[people] ([name], [email], [address]) VALUES('{name}','{email}','{address}');\n")
        f.close()

if __name__ == "__main__":
    main()