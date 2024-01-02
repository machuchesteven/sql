# create table [dbo].[products] (
#  id int identity primary key,
#  name varchar(50),
#  description text unique,
#  price numeric(10, 2),
#  stock int,
#  date_added date,
# );

# CREATING A REFERENCE FROM ONE TABLE TO ANOTHER
# create table [dbo].[products] (
#  id int identity primary key,
#  name varchar(80),
#  description text unique,
#  price numeric(10, 2),
#  stock int,
#  date_added date not null constraint DF_Product_Added_Date default getdate(), // date_added date not null  default getdate()
#  category_id int,
#  constraint FK_Products_Category
#  foreign key (category_id)
# );


#  TRYING CREATING THE RELATIONSHIP WITHOUT RELATIONSHIP NAME
# create table [dbo].[products] (
#  id int identity primary key,
#  name varchar(80),
#  description text,
#  price numeric(10, 2),
#  stock int,
#  date_added date not null default getdate(),
#  category_id int null,
#  constraint FK_Products_Categories foreign key (category_id) references [dbo].[categories](id) on delete no action
# );


# drop table products;

# create proc sp_add_product(@name varchar(80), @description text, @price numeric(10,2), @stock int, @category_id int null)
# as
# begin 
# insert into products(name, description, price, stock, category_id) values (@name, @description, @price, @stock, @category_id)
# end
# go
