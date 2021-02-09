
-- определение фамили сотрудника, зарплаты которых выше 2000;
select empno, [ENAME], SAL
from [dbo].[user00_EMP]
where SAL > 2000;

-- найти отделы, которые наход€тс€ в ƒалласе;
select DNAME, LOC
from user00_DEPT
where LOC = 'DALLAS';

-- определить фамилии сотрудников из отдела 20;
select empno, [ENAME], hiredate
from [dbo].[user00_EMP]
where [DEPTNO]=20

-- найти сотрудника, чьим начальником €вл€етс€ сотрудник 7839;
select empno, [ENAME], mgr, hiredate
from [dbo].[user00_EMP]
where [mgr]=7839;

-- сортировка сотрудников их дате найма;
select *
from [dbo].[user00_EMP]
order by  hiredate desc;