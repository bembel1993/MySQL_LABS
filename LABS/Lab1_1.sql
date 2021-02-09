
-- ����������� ������ ����������, �������� ������� ���� 2000;
select empno, [ENAME], SAL
from [dbo].[user00_EMP]
where SAL > 2000;

-- ����� ������, ������� ��������� � �������;
select DNAME, LOC
from user00_DEPT
where LOC = 'DALLAS';

-- ���������� ������� ����������� �� ������ 20;
select empno, [ENAME], hiredate
from [dbo].[user00_EMP]
where [DEPTNO]=20

-- ����� ����������, ���� ����������� �������� ��������� 7839;
select empno, [ENAME], mgr, hiredate
from [dbo].[user00_EMP]
where [mgr]=7839;

-- ���������� ����������� �� ���� �����;
select *
from [dbo].[user00_EMP]
order by  hiredate desc;