use master
go

drop database DBDemo
go

-- Create the database, if it does not already exist.
if not exists(select * from sys.databases where name = 'DBDemo')
	begin
		create database DBDemo
	end
go

-- Use the database
use DBDemo
go

if (OBJECT_ID('Lokation') is null)
	begin
		create table Lokation
		(LokationID nchar(2) primary key not null,
		Kontinent varchar(50) not null)
	end
go

if (OBJECT_ID('Type') is null)
	begin
		create table Type
		(TypeID int primary key identity(1,1),
		Element varchar(50) not null)
	end
go

if (OBJECT_ID('Styrke') is null)
	begin
		create table Styrke
		(StyrkeID int primary key identity(1,1),
		Styrke varchar(50) not null)
	end
go

if (OBJECT_ID('Svaghed') is null )
	begin
		create table Svaghed
		(SvaghedID int primary key identity(1,1),
		Svaghed varchar(50) not null)
	end
go

if (OBJECT_ID('Art') is null)
	begin
		create table Art
		(ArtID int primary key identity(1,1),		
		Type int foreign key(Type) references Type(TypeID) not null,
		Levested nchar(2) foreign key(Levested) references Lokation(LokationID) not null,
		Navn varchar(50) not null)
	end
go

if (OBJECT_ID('ArtStyrke') is null)
	begin
		create table ArtStyrke
		(Art int foreign key(Art) references Art(ArtID) not null,
		 Styrke int foreign key(Styrke) references Styrke(StyrkeID) not null) --foreign key
	end
go

if (OBJECT_ID('ArtSvaghed') is null)
	begin
		create table ArtSvaghed
		(Art int foreign key(Art) references Art(ArtID) not null,
		Svaghed int foreign key(Svaghed) references Svaghed(SvaghedID) not null) --foreign key
	end
go

if (OBJECT_ID('Monster') is null) 
	begin
		create table Monster
		(MonsterID int primary key identity(1,1),
		 Navn varchar(50) not null,
		 Art int foreign key(Art) references Art(ArtID) not null) --foreign key
	end
go

--insert kommandoer til alle tabellerne.

if (select count(*) from Lokation) = 0
	begin
		insert into Lokation(LokationID, Kontinent) 
		values	('AF', 'Africa'),
				('AN', 'Antarctica'),
				('AS', 'Asia'),
				('EU', 'Europe'),
				('NA', 'North America'),
				('OC', 'Oceania'),
				('SA', 'South America');
	end
go

if (select count(*) from Type) = 0
	begin
		insert into Type(Element)
		values	('Earth'),
				('Water'),
				('Air'),
				('Fire'),
				('Ice'),
				('Light'),
				('Dark');
	end
go

if (select count(*) from Styrke) = 0
	begin
		begin transaction readStyrkefromfile
		bulk insert DBDemo.dbo.Styrke
		from 'C:\SQL\Styrker.csv'
		with
			(
				firstrow = 1,
				codepage = 'ACP',
				fieldterminator = ';',
				datafiletype = 'char',
				rowterminator = '\n'
			)
		
		if @@error <> 0
			begin
				Print 'Der er opstået fejl'
				rollback transaction readStyrkefromfile
			end
			else
			begin
				print 'Indlæsning komplet'
				commit transaction readStyrkefromfile
			end
	end
go

if (select count(*) from Svaghed) = 0
	begin
		begin transaction readSvaghedfromfile
		bulk insert DBDemo.dbo.Svaghed
		from 'C:\SQL\Svagheder.csv'
		with
			(
				codepage = 'ACP',
				firstrow = 1,
				fieldterminator = ';',
				datafiletype = 'char',
				rowterminator = '\n'
			)
		
		if @@error <> 0
			begin
				Print 'Der er opstået fejl'
				rollback transaction readSvaghedfromfile
			end
			else
			begin
				print 'Indlæsning komplet'
				commit transaction readSvaghedfromfile
			end
	end
go

if (select count(*) from Art) = 0
	begin
		begin transaction readArtfromfile
		bulk insert DBDemo.dbo.Art
		from 'C:\SQL\ART.csv'
		with
			(
				codepage = 'ACP',
				firstrow = 1,
				fieldterminator = ';',
				datafiletype = 'char',
				rowterminator = '\n'
			)
		
		if @@error <> 0
			begin
				Print 'Der er opstået fejl'
				rollback transaction readArtfromfile
			end
			else
			begin
				print 'Indlæsning komplet'
				commit transaction readArtfromfile
			end
	end
go


if (select count(*) from Monster) = 0
	begin
		begin transaction readMonsterfromfile
		bulk insert DBDemo.dbo.Monster
		from 'C:\SQL\MonsterTabel.csv'
		with
			(
				codepage = 'ACP',
				firstrow = 2,
				fieldterminator = ';',
				datafiletype = 'char',
				rowterminator = '\n'
			)
		
		if @@error <> 0
			begin
				Print 'Der er opstået fejl'
				rollback transaction readMonsterfromfile
			end
			else
			begin
				print 'Indlæsning komplet'
				commit transaction readMonsterfromfile
			end
	end
go

if (select count(*) from ArtSvaghed) = 0
	begin
		begin transaction readArtSvaghedfromfile
		bulk insert DBDemo.dbo.ArtSvaghed
		from 'C:\SQL\art-svaghed.csv'
		with
			(
				codepage = 'ACP',
				firstrow = 2,
				fieldterminator = ';',
				datafiletype = 'char',
				rowterminator = '\n'
			)
		
		if @@error <> 0
			begin
				Print 'Der er opstået fejl'
				rollback transaction readArtSvaghedfromfile
			end
			else
			begin
				print 'Indlæsning komplet'
				commit transaction readArtSvaghedfromfile
			end
	end
go

if (select count(*) from ArtStyrke) = 0
	begin
		begin transaction readArtstyrkefromfile
		bulk insert DBDemo.dbo.Artstyrke
		from 'C:\SQL\art-styrke.csv'
		with
			(
				codepage = 'ACP',
				firstrow = 2,
				fieldterminator = ';',
				datafiletype = 'char',
				rowterminator = '\n'
			)
		
		if @@error <> 0
			begin
				Print 'Der er opstået fejl'
				rollback transaction readArtstyrkefromfile
			end
			else
			begin
				print 'Indlæsning komplet'
				commit transaction readArtstyrkefromfile
			end
	end
go