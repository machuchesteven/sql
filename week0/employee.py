from faker import Faker

fake = Faker()

def fake_first_name():
    name = fake.first_name()
    return name

def fake_last_name():
    return fake.last_name_male()

def fake_date():
    date = fake.date_this_century().strftime("%Y-%m-%d") # this is the format for SQL server
    return date
# fake.unique.random_int(2, 200) getting a random number within a certain range

def add_employees():
    with open("employees.sql", "w") as f:
        for i in range(2, 100):
            f.write(f"insert into [dbo].[employee] (id,first_name, last_name, is_retired, joined) values ({i},'{fake_first_name()}', '{fake_last_name()}', 0, '{fake_date()}');\n")
        print("Sample employee created")
        f.close()

add_employees()

# create proc sp_add_employee(@FirstName varchar(50), @LastName varchar(50), @IsRetired bit)
# as
# begin 
# insert into employee(first_name,last_name,is_retired,joined) values (@FirstName, @LastName, @IsRetired, GETDATE())
# end
# go