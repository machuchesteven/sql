#  create table [dbo].[user] (
#   id int identity primary key,
#   username varchar(50) unique,
#   email varchar(50) unique,
#   phone varchar(12),
#   dob date,
#   is_active bit,
#  );
#   above is the data structure of the sql table
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

# def add_employees():
#     with open("employees.sql", "w") as f:
#         for i in range(2, 100):
#             f.write(f"insert into [dbo].[employee] (id,first_name, last_name, is_retired, joined) values ({i},'{fake_first_name()}', '{fake_last_name()}', 0, '{fake_date()}');\n")
#         print("Sample employee created")
#         f.close()



def create_user_table():
    with open("user.sql", "w") as f:
        for i in range(2, 100):
            f.write(f"insert into [dbo].[employee] (id,first_name, last_name, is_retired, joined) values ({i},'{fake_first_name()}', '{fake_last_name()}', 0, '{fake_date()}');\n")
        print("Sample employee created")
    return "created"


create_user_table()