CREATE TABLE Повышение_квалификации(
	НомерГруппы int NOT NULL,
	Количество_студентов int NOT NULL,
	ФИО_преподавателя nvarchar(50) NOT NULL,
	Телефон int NULL,
	Стаж int NULL,
	Предмет nvarchar(50) NOT NULL,
	Количество_часов int NOT NULL,
	Тип_занятия nvarchar(50) NOT NULL,
	Сумма_к_оплате int NOT NULL,
	Начало_занятий int NOT NULL,
	Окончание_занятий int NOT NULL,
CONSTRAINT РК_Повышение_квалификации PRIMARY KEY (НомерГруппы));

CREATE TABLE Группа(
	НомерГруппы int NOT NULL,
	Количество_студентов int NOT NULL,
CONSTRAINT РК_Группа PRIMARY KEY (НомерГруппы));

CREATE TABLE Занятие(
	Предмет nvarchar(50) NOT NULL,
	Количество_часов int NOT NULL,
CONSTRAINT РК_Занятие PRIMARY KEY (Предмет));

CREATE TABLE Тип(
	Тип_занятия nvarchar(50) NOT NULL,
	Сумма_к_оплате int NOT NULL,
CONSTRAINT РК_Тип PRIMARY KEY (Тип_занятия));

CREATE TABLE Время(
	Начало_занятий int NOT NULL,
	Окончание_занятий int NOT NULL,
CONSTRAINT РК_Время PRIMARY KEY (Начало_занятий));

CREATE TABLE Преподаватель(
	ФИО_преподавателя nvarchar(50) NOT NULL,
	Телефон int NULL,
	Стаж int NULL,
CONSTRAINT РК_Преподаватель PRIMARY KEY (ФИО_преподавателя));

