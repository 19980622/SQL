1]

SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('19810101', 'YYYYMMDD') AND hiredate <= TO_DATE('19830101', 'YYYYMMDD');

2]

SELECT *
FROM emp
WHERE job = 'SALESMAN' AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

3]

SELECT *
FROM emp
WHERE deptno NOT IN (10) AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

4]
SELECT ROWNUM, a.*
FROM
    (SELECT empno, ename
     FROM emp
     ORDER BY empno)a;
 
 5]
 
 SELECT *
 FROM emp
 WHERE deptno IN (10, 30) AND sal>1500
 ORDER BY ename DESC;
 
 6]
 
SELECT deptno "deptno", MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal
FROM emp
GROUP BY deptno;

7]

SELECT e.empno, e.ename, e.sal, e.deptno, d.dname
FROM emp e, dept d
WHERE d.dname = 'RESEARCH' AND e.deptno = 20 AND e.empno > 7600 AND sal > 2500;

8]

SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.deptno IN (10, 30);

9]

SELECT ename, DECODE(mgr, 7902, 'FORD', 7698, 'BLAKE', 7839, 'KING', 7566, 'JONES', 7788, 'SCOTT', 7782, 'CRARK', (null), 'NULL') mgr
FROM emp
ORDER BY mgr;


10]

SELECT hire_yyyymm, COUNT(hire_yyyymm) cnt
FROM
    (SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm
     FROM emp)
     GROUP BY hire_yyyymm;

11]

SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));

12] 

SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);

13]
INSERT INTO dept(deptno,dname,loc) VALUES (99,'ddit','대전');

14]

UPDATE dept
SET dname = 'ddit_modi', loc = '대전_modi'
WHERE deptno = 99;

15]
DELETE dept
WHERE deptno = 99;




------------------???
16] ????
CREATE TABLE emp(;
CREATE TABLE dept;

17] 
민규야~ 오늘도 힘내서 으쌰으쌰 하댜!!٩(๑>∀<๑)۶
SELECT deptno, SUM(sal)
FROM emp 
GROUP BY ROLLUP (deptno);

18]
SELECT *
FROM
((SELECT deptno
FROM emp
WHERE deptno IN (10))
UNION ALL
(SELECT deptno
FROM emp
WHERE deptno IN (20))
UNION ALL
(SELECT deptno
FROM emp
WHERE deptno IN (30));

19]

20]





























































