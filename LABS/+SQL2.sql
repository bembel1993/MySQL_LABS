CREATE TABLE ������
     (���_���� integer NOT NULL,
		��� CHAR(20) NOT NULL,
		���� INTEGER NOT NULL,
 PRIMARY KEY (���_����));

INSERT INTO ������ VALUES(101, '������ �.�.', 20);
INSERT INTO ������ VALUES(102, '������� �.�.', 30);
INSERT INTO ������ VALUES(103, '���������� �.�.',10);
INSERT INTO ������ VALUES(104, '������� �.�.', 5);
INSERT INTO ������ VALUES(105, '������� �.�.', 10);
----------------
CREATE TABLE �������
   (ID_������� INT NOT NULL,
             CHECK (ID_������� BETWEEN 101 AND 199),
        �������� VARCHAR(20) NOT NULL,
         ��_��� INTEGER,
		��_�� INTEGER,
 PRIMARY KEY (ID_�������));

INSERT INTO ������� VALUES(101, '����������',58, 60);
INSERT INTO ������� VALUES(102, '����������',48, 50);
INSERT INTO ������� VALUES(103, '�������',60, 60);
INSERT INTO ������� VALUES(104, '�����',38, 30);
INSERT INTO ������� VALUES(105, '�����������',28, 20);
--------------------------
CREATE TABLE ���_�
   (��� INTEGER    NOT NULL,
    ���_������� VARCHAR(20) NOT NULL,
    �����_�_������ INTEGER,
 PRIMARY KEY (���));

INSERT INTO ���_� VALUES(1, '������',2000);
INSERT INTO ���_� VALUES(2, '����',2500);
-----------------------------
CREATE TABLE ���_��
  (ID_��� INTEGER NOT NULL,
       ���_�������� varchar(20),      
  ���_��� DATE NOT NULL,
  ��_��� DATE NOT NULL,
        ID_��� INTEGER NOT NULL,
         ���_�������� INTEGER,
         ID_���� INTEGER NOT NULL,
 PRIMARY KEY (ID_���),
 FOREIGN KEY (ID_���)
  REFERENCES ���_�(���)ON UPDATE CASCADE
   ON DELETE CASCADE,
 FOREIGN KEY (���_��������)
  REFERENCES �������(ID_�������)ON UPDATE CASCADE,
 FOREIGN KEY (ID_����)
  REFERENCES ������(���_����)ON UPDATE CASCADE);

INSERT INTO ���_�� VALUES(101, '����������', '2007-08-17', '2007-12-17', 1, 101, 101);
INSERT INTO ���_�� VALUES(102, '����������', '2007-08-17', '2007-12-17', 2, 102, 102);
INSERT INTO ���_�� VALUES(103, '�������', '2007-08-17', '2007-12-17', 1, 103, 103);
INSERT INTO ���_�� VALUES(104, '�����', '2007-08-17', '2007-12-17', 1, 104, 104);
INSERT INTO ���_�� VALUES(105, '�����������', '2007-08-17', '2007-12-17', 2, 105, 105);

UPDATE ���_�� SET ID_���=108, ���_��������='����������������' WHERE ID_��� = 104;
delete ���_�� WHERE ID_��� = 108;

select ID_���, ���_�������� 
from ���_��
where ���_�������� like '���%';

select *
from �������