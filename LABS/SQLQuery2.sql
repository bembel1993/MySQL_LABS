CREATE TABLE ���������_������������(
	����������� int NOT NULL,
	����������_��������� int NOT NULL,
	���_������������� nvarchar(50) NOT NULL,
	������� int NULL,
	���� int NULL,
	������� nvarchar(50) NOT NULL,
	����������_����� int NOT NULL,
	���_������� nvarchar(50) NOT NULL,
	�����_�_������ int NOT NULL,
	������_������� int NOT NULL,
	���������_������� int NOT NULL,
CONSTRAINT ��_���������_������������ PRIMARY KEY (�����������));

CREATE TABLE ������(
	����������� int NOT NULL,
	����������_��������� int NOT NULL,
CONSTRAINT ��_������ PRIMARY KEY (�����������));

CREATE TABLE �������(
	������� nvarchar(50) NOT NULL,
	����������_����� int NOT NULL,
CONSTRAINT ��_������� PRIMARY KEY (�������));

CREATE TABLE ���(
	���_������� nvarchar(50) NOT NULL,
	�����_�_������ int NOT NULL,
CONSTRAINT ��_��� PRIMARY KEY (���_�������));

CREATE TABLE �����(
	������_������� int NOT NULL,
	���������_������� int NOT NULL,
CONSTRAINT ��_����� PRIMARY KEY (������_�������));

CREATE TABLE �������������(
	���_������������� nvarchar(50) NOT NULL,
	������� int NULL,
	���� int NULL,
CONSTRAINT ��_������������� PRIMARY KEY (���_�������������));

