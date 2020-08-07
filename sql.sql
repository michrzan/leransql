select * from CapeTown.Doctor as d
select * from CapeTown.Doctor as "d"
select * from CapeTown.Doctor d
select * from CapeTown.Doctor "d"

---

alter table CapeTown.Patient 
drop constraint FK__Patient__AppId__3F466844


alter table capetown.patient drop column appid


select * from dbo.Drugs
--10, 11, 12
insert into dbo.Drugs values('panado'), ('granpa'), ('coldrex')
--delete from dbo.Drugs


select * from capetown.patient

insert into capetown.Patient values 
(N'reynard', N'234 main rd', N'+270123456789', 232, Null, N'o +', 2)

insert into capetown.Patient values 
(N'toto', N'777 main rd', N'+2799999999', 111, 10, N'a +', 1),
(N'smith', N'1 main rd', N'+48000000000', 666, 12, N'a -', 1)

insert into capetown.Patient values 
(N'abraham lincoln', N'white house 3', N'+19343499999', 31, 11, N'a +', 1),
(N'calvin coolidge', N'white house 2', N'+18005340000', 626, 12, N'a -', 1)

declare @patient_info table
(
[name] nvarchar(max),
[address] nvarchar(max),
cellphone nvarchar(13),
medinf int,
drugid int,
blood nvarchar(max),
docid int
)

insert into @patient_info values
(
N'Johny', N'1 long st', N'125478554', 123, 12, N'A+', 1
)

insert into CapeTown.Patient
--(PatientName, [Address], PhoneNumber, HealthRecordNo, DrugsId, BloodTest, DoctorId)
 select * from @patient_info

 select * from CapeTown.patient

 delete from CapeTown.patient where PatientName = 'Johny'



 alter table CapeTown.Doctor
 add DoctorPatientId int foreign key references CapeTown.Doctor(DoctorId);
 update CapeTown.Doctor set DoctorPatientId =  null
 update CapeTown.Doctor set DoctorPatientId = 3 where DoctorID = 4
 update CapeTown.Doctor set DoctorPatientId = 2 where DoctorID = 3
 update CapeTown.Doctor set DoctorPatientId = 1 where DoctorID = 6

 insert into CapeTown.Doctor ([name], [Address], [Specialization], BranchId)
  --values ('John', 'Hospital', 'Oncologist', 1)
  --values ('Brian', '1 long street', 'dermatologist', 1)
  values ('George', '2 long street', 'GP', 1)
  

 select * from CapeTown.Doctor

 select d.name "Doctor Name", dp.name "Patient Name"
 from CapeTown.Doctor d
 inner join CapeTown.Doctor dp
 on d.DoctorID = dp.doctorpatientid


 declare @h as decimal = 20.22;
 declare @p money;

 set @p = parse(@h as money using 'de-DE');
 select @p;


 declare @p as money
 set @p = parse('20,01' as money using 'de-de')
 select @p
 



declare @i int;
set @i = 1;
declare @s varchar(max);
set @s = '*'

declare @t table(
id int Identity ,
stars varchar(max));

while @i <= 20
begin
insert into @t values (@s)
set @s = @s + '*'
set @i = @i +1
end
select stars from @t order by id desc;



declare @num int = 4

select d.[name], d.[specialization]
from CapeTown.Doctor as d
where d.DoctorID = (select max(doctorid) from CapeTown.Patient);


--correlated subquery---


select *-- d.[name], d.[specialization], d.DoctorID
from CapeTown.doctor as d
where d.doctorid =  
(
select max(d1.doctorid) from CapeTown.doctor as d1
--where d.branchid = d1.branchid 
)


---



select * from CapeTown.doctor


select ROW_NUMBER() over ( partition by [address] order by doctorid) as noodoc, [name], [Address]
from CapeTown.doctor

use healthCareDatabase

select * from CapeTown.doctor



select d.name, d.address
from CapeTown.Doctor d
order by d.Address
offset 2 rows fetch next 2 rows only



---


create proc CapeTown.GetPatientInfoPerPage
(
@pageNo int,
@pageSize int
)
as
begin
select p.PatientId, p.PatientName, p.PhoneNumber, p.HealthRecordNo
from CapeTown.Patient as p
order by p.PatientId
offset (@pageNo - 1) * @pageSize rows
fetch next @pageSize rows only
end
go


select * from CapeTown.Patient

exec CapeTown.GetPatientInfoPerPage 1,2
exec CapeTown.GetPatientInfoPerPage 2,2
exec CapeTown.GetPatientInfoPerPage 3,2


---

select d.[Name], d.Specialization--, pa.*
from CapeTown.doctor as d;

------cross apply--------

select d.[Name], d.Specialization, pa.*
from CapeTown.doctor as d
cross apply 
(select p.patientname, p.address
from CapeTown.Patient as p
where p.DoctorId = d.DoctorID
order by d.DoctorID asc
offset 0 row fetch next 2 rows only) as pa




------outer apply--------

select d.[Name], d.Specialization, pa.*
from CapeTown.doctor as d
outer apply 
(select p.patientname, p.address
from CapeTown.Patient as p
where p.DoctorId = d.DoctorID
order by d.DoctorID asc
offset 0 row fetch next 2 rows only) as pa



select * from CapeTown.Patient

select p.patientid, count(*) over (partition by p.BloodTest order by p.patientid), p.BloodTest
as numofpat
from CapeTown.Patient as p


select count(*), p.BloodTest
from CapeTown.Patient as p
group by p.BloodTest


---

select * from CapeTown.Patient
select * from CapeTown.doctor
select * from dbo.Branch

update CapeTown.Doctor set BranchId = 1002 where DoctorID =6 

update CapeTown.Patient set DoctorId = 6 where PatientId > 1000
---


select * 
from CapeTown.Patient
where DoctorId = 6


select count(p.patientid) "no of pat", p.BloodTest--,  p.DoctorId
from CapeTown.Patient as p
group by GROUPING sets
(
--(DoctorId, BloodTest),
--(DoctorId),
(BloodTest),
()
)


------cube-----
select count(p.patientid) "no of pat", p.BloodTest,  p.DoctorId
from CapeTown.Patient as p
group by cube(DoctorId, BloodTest)



---rollup---

select p.PatientName, d.Name as doctorname, b.BranchName
from CapeTown.Patient as p
inner join CapeTown.Doctor as d
on p.DoctorId = d.DoctorID
inner join dbo.Branch as b
on d.DoctorID = b.BranchId
group by rollup(b.BranchName, d.Name, p.PatientName)


-----
select * from capetown.docrep(1)

create synonym capetown.docrep for capetown.dctorreportpam

select * from capetown.docrep 1



----------------select into-------------------------

declare @table1 table (id int, [text] varchar(max));
declare @table2 table (id int, [text] varchar(max));

insert into @table1 values(132,'LOL');
select * from @table1;

insert into @table2 select * from @table1

select * from @table2;


----------------insert into-------------------------


--create  table #table1 (id int, [text] varchar(max));



--insert into #table1 values(132,'LOL');

create table #table2  (id int, [text] varchar(max));

select * into lol from #table1;

select * from lol;

DROP TABLE LOL


-------insert into execute-------

declare @table1 table (id int, [text] varchar(max));



-----------identity-------------

declare @identitytable table(id int identity(0,10), num int);

insert into @identitytable values (5),(6),(7),(8),(9);
select * from @identitytable 


create sequence capetown.numgen as int
minvalue 1 
cycle;
go


declare @sequencetable table (id int, val char(10));
insert into @sequencetable values
(next value for capetown.numgen, 'chleb'),
(next value for capetown.numgen, 'dom'),
(next value for capetown.numgen, 'kot')
select * from @sequencetable


-----dynamic sql-----

declare @script nvarchar(max);
set @script = N'select * from capetown.patient'

exec(@script)


----

create proc dbo.createtables
as
begin


			declare @branchno int = 1005--(select count(*) from dbo.Branch)
			declare @count int = 1004;
			declare @create_table nvarchar(max);
			declare @tablename nvarchar(max);
			declare @q1 nvarchar(max);

			while (@branchno >= @count)
			begin

			set @tablename = (select [BranchName] from dbo.Branch where BranchId = @count)
			set  @q1 = N'
			CREATE TABLE  ' + @tablename + '.[Doctor](
				[DoctorID] [int] IDENTITY(1,1) NOT NULL,
				[Name] [nvarchar](100) NOT NULL,
				[Address] [nvarchar](max) NOT NULL,
				[Specialization] [varchar](max) NULL,
				[BranchId] [int] NOT NULL,
				[DoctorPatientId] [int] NULL,
			PRIMARY KEY CLUSTERED 
			(
				[DoctorID] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];

			ALTER TABLE  ' + @tablename + '.[Doctor]  WITH CHECK ADD FOREIGN KEY([BranchId])
			REFERENCES [dbo].[Branch] ([BranchId]);

			ALTER TABLE  ' + @tablename + '.[Doctor]  WITH CHECK ADD FOREIGN KEY([DoctorPatientId])
			REFERENCES  ' + @tablename + '.[Doctor] ([DoctorID]);
			'

			exec(@q1)
			set @count = @count + 1
			end

end
go

exec dbo.createtables
---
--CREATE SCHEMA Jozzy
drop table Jozzy.Doctor
drop table Pretoria.Doctor



-------------------

declare @branchno int = 1005
declare @my_tablename nvarchar(max);
declare @my_table varchar(60);
declare @q1 nvarchar(max);

set @my_tablename = (select [BranchName] from dbo.Branch where BranchId = 1005)--@count)

set  @q1 = N'
			CREATE TABLE   @my_table.[Doctor](
				[DoctorID] [int] IDENTITY(1,1) NOT NULL,
				[Name] [nvarchar](100) NOT NULL,
				[Address] [nvarchar](max) NOT NULL,
				[Specialization] [varchar](max) NULL,
				[BranchId] [int] NOT NULL,
				[DoctorPatientId] [int] NULL,
			PRIMARY KEY CLUSTERED 
			(
				[DoctorID] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];

			ALTER TABLE   @my_table.[Doctor]  WITH CHECK ADD FOREIGN KEY([BranchId])
			REFERENCES [dbo].[Branch] ([BranchId]);

			ALTER TABLE   @my_table.[Doctor]  WITH CHECK ADD FOREIGN KEY([DoctorPatientId])
			REFERENCES   @my_table.[Doctor] ([DoctorID]);
			'
select * from dbo.Drugs

----------------------CROSS JOIN / CROSS APPLY / INNER JOIN ---------------------

---???

---back to dynamic sql---

declare @sqlstring1 as nvarchar(max) = N'
select [Name], [Specialization] from CapeTown.Doctor where DoctorID =  @id
'

exec sp_executesql
@statement = @sqlstring1, @params = N'@id int', @id = 1;



declare @drug1 varchar(30) = 'another medicine 23';
declare @sqlstring3 nvarchar(max) = N'insert into dbo.drugs values(@drug)';

exec sp_executesql @statement = @sqlstring3, 
@params = N'@drug nvarchar(100)', 
@drug = @drug1;


select * from dbo.drugs


---transactions---

begin try
	begin tran
		declare @drug1 varchar(30) = 'yet another drug 16662';
		declare @sqlstring3 nvarchar(max) = N'insert into dbo.drugs values(@drug), (@XXX)';
		exec sp_executesql @statement = @sqlstring3, 
			@params = N'@drug nvarchar(100)', 
			@drug = @drug1;
		commit
	end try
	begin catch
		rollback
	end catch
--end

select * from dbo.drugs


---transactions-with-mark------
begin try
begin tran with mark

	select * from CapeTown.Doctor;
	select @@TRANCOUNT as firstlevel;
	select XACT_STATE() as state;
	/* 0	this transaction is not active; 
	   1	this transaction is active but not yet commited 
	   -1	this transaction cannot be commited */
	begin tran
		select * from CapeTown.Patient;
		select @@TRANCOUNT as secondlevel;
		commit
		
	end try
	begin catch
		rollback
	end catch



---------coalesce-------

	declare @value varchar(100) = NULL;
	select @value;
	select coalesce(@value, 'XD')
	select coalesce(@value, NULL, @value, NULL, 'HH', 'XD')
--
declare @value2 varchar(100) = NULL;
declare @value3 varchar(100) = 'foo';
select isnull(@value2, 'XD')
select isnull(@value3, 'DD')


declare @value4 varchar(3) = NULL;
declare @value5 varchar(10) = 'qwertyuiop';
select coalesce(@value4, @value5), isnull(@value4, @value5)


-------nullif-------
declare @i int = 10, @y int = 10;
select nullif(@i, @y)
SELECT NULLIF(4,4) AS Same, NULLIF(5,7) AS Different;



---iif-----

select iif(10 > 5, 'yes', 'no')
select iif(10 < 5, 'yes', 'no')


---choose----
declare @choice int = 2 ;
select choose(@choice, 'a', 'b', 'c')

------ merge -----

create schema src
go

create schema destination
go

create table destination.Product
(
productId int identity,
productName nvarchar(100)
)
go

insert into src.Product values ('rock'), ('smith');


select * from src.Product 


--merging both tables--

merge into destination.Product as Tgt
using src.Product as src
on Tgt.productid = src.productid
when matched then
update set Tgt.productname = src.productname
when not matched by target then -- "by target" or "by source"
insert(productname) values(src.Productname);


select * from destination.Product;
select * from src.Product;


--------triggers--- 

create trigger capetown.modifyDoctor
on CapeTown.doctor
for delete, update, insert
as 
begin
print 'manipulation happened on the doctor table xD'
end
go

delete from CapeTown.Doctor where DoctorID = 4

--insert into CapeTown.Doctor values ('Damian', 'Beverly Hills', 'GP', 2, NULL)
--select * from CapeTown.Doctor


--when not matched by target then
--insert into tgt values(src.productname);

go


create trigger capetown.modifyPatient
on CapeTown.patient
instead of delete, update, insert
as 
begin
print 'you cannot modify this table xD'
end
go


delete from CapeTown.patient where patientid = 1008
select * from CapeTown.patient;



--afret of trigger---


create trigger dbo.ModifyDrugs
on dbo.Drugs
after delete, update, insert
as
begin
select i.DrugName as insertedDrug from inserted as i
select d.DrugName as deletedDrug from deleted as d
end
go

insert into dbo.Drugs values ('new drug 8')
select * from dbo.Drugs 
delete from dbo.Drugs where DrugId = 1007


---pivoting---
