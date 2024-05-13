create table demologs(
id int primary key,
itemName varchar(100),
created_at datetime default getdate())
GO


create trigger demo_trigger 
on demo
after insert
as
begin
	set NOCOUNT ON;
	DECLARE @DemoId INT;
	DECLARE @Name VARCHAR(100);
	select @DemoId = inserted.id
	from inserted;

	insert into demologs(id)
	values(@DemoId) 
end
go


insert into demo(id, itemName)
values(1,'hello')

select * from demologs