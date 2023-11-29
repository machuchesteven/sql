from faker import Faker
fake = Faker()


def create_table(table_name, rows_number:int|None = None, columns_number:int|None = None):
    print("You are about to create a new table script with pregenerated data")
    if columns_number != None: 
        print(f"""
        Your are creating a sample table with the following characteristics:-
            \t{table_name} as the TABLE_NAME,
            \t{rows_number} as the ROWS_NUMBER
            \t{columns_number} as the COLUMNS_NUMBER
            This means your table will be named \n{table_name} with {columns_number} attributes and {rows_number} sample data,\n
        \nDo you want continue? Yes/No\n\t Yes/Y to continue.\n\tNo/No to change details
    """)
        choice:str = input("\t:")
        if choice.lower() == "yes" or choice.lower() == "y" or choice.lower() == "ye" or choice.lower() == "":
            pass
        elif choice.lower() == "cancel":
            print("You chose to cancel, bye bye!")
            return False
        else:
            columns_number = int(input("Please Enter the number of columns"))
            rows_number = int(input("Please Enter the number of rows"))
    else:
        columns_number = int(input("Please Enter the number of columns"))
        rows_number = int(input("Please Enter the number of rows"))
    columns =[]
    active_col = 0
    data_types = ["numeric", "string", "date_time", "boolean"]
    while active_col < columns_number:
        col_name = input("Enter the column name: \t")
        print("Columns can be of the following DATA TYPE:\n\t1: numeric, 2: character string, 3: dates and times, 4: Boolean")
        data_type_choice = int(input("Enter the datatype:"))
        if data_type_choice == 1:
            int_type = int(input("Enter the type: 1 for int, 2 for float, or 4 float"))
            if int_type == 1:
                data_type = "integer"
            elif int_type == 2:
                data_type_choice = "decimal(10,2)"
        elif data_type_choice == 2:
            try:
                max_length = int(input("Enter the max length"))
                data_type = f"varchar({max_length})"
            except Exception as e:
                print("An error occurred during selecting the max length of the column.")
                data_type = "text"
        elif data_type_choice == 3:
            data_type = "timestamp"
        elif data_type_choice == 4:
            data_type = "boolean"
        else:
            print("Data will be integer")
            data_type_choice = "integer"
        col = {"name": col_name, "type": data_type}
        columns.append(col)
    definitions = ""
    for col in columns:
        definitions += f"{col['name']} {col['type'], }"
        print(definitions)
    create_string = F"CREATE TABLE {table_name}(id serial primary key, {definitions})"
    for row in range(0, rows_number):
        print(f"insert into {table_name}")
    with open(f"{table_name}.sql", "w") as tb:
        tb.write(f"{create_string};\n")



def data_by_type(dt:str):
    if not dt:
        fake_dt = "varchar(20)"
        fake.sentence(20)
    elif dt.lower() == "integer":
        data = fake.integer()

def fake_name():
    name = fake.name().split(" ")[0]
    return name

def fake_description(words:int):
    return fake.sentence(words)

def fake_address():
    fake.address()