PL/SQL로 간격의 평균값 구하기

PL/SQL 에서는 변수를 DECLARE 에서 선언한다.

프로시져명 : avgdt

SELECT *
FROM dt;
의 여러 행값을 각각 담을 수 있는 변수를 선언해서 거기에 값을 담고 => 루프를 돌면서 값을 꺼낸다

여러행의 데이터를 가져오는 방법 : 2가지

1. 테이블 타입 변수에 우리가 필요로 하는 전체 테이블의 데이터를 전부 담아서 처리 //이 방법이 아직더 편하다?
2. cursor (를 통해 sql을 직접 제어) : 선언 - open - fetch (배운내용으로는 1건씩) - close

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE avgdt IS
    TYPE t_dt IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER; --여러건을 담을 수 있는 타입 t_dt 선언
    v_dt t_dt; --t_dt의 타입의 v_dt를 선언
    
    v_diffSum NUMBER := 0; -- pl/sql 에서 대입연산자는 :=
BEGIN
    SELECT * BULK COLLECT INTO v_dt -- 정보가 담기게 된다
    FROM dt;
    
    FOR i IN 1..v_dt.count-1 LOOP
        v_diffSum := v_diffSum + v_dt(i).dt - v_dt(i+1).dt;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE( v_diffSum / (v_dt.count-1) );
END;
/

PL/SQL을 반드시 써야 되는 경우가 아니면 SQL이 더 빠르다.

EXEC avgdt;


CREATE TABLE dt AS
SELECT SYSDATE dt FROM dual UNION ALL
SELECT SYSDATE -5 FROM dual UNION ALL
SELECT SYSDATE -10 FROM dual UNION ALL
SELECT SYSDATE -15 FROM dual UNION ALL
SELECT SYSDATE -20 FROM dual UNION ALL
SELECT SYSDATE -25 FROM dual UNION ALL
SELECT SYSDATE -30 FROM dual UNION ALL
SELECT SYSDATE -35 FROM dual;

ana6]
SELECT empno, ename, hiredate, job, sal, 
       LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

SELECT sal, comm, sal-comm, LAG(SAL) OVER (OR
FROM emp;

SELECT AVG(diff)
FROM
(SELECT dt, LEAD(dt) OVER (ORDER BY dt DESC) lead_dt, dt - LEAD(dt) OVER (ORDER BY dt DESC) diff 
-- 행간 연산의 약점을 보안하기 위해서 사용하는 분석함수(LEAD, LAG), 분석함수는 OVER 라는 키워드가 필수로 사용되고 분석 함 수 사용을 위해 정렬이 되어있는 환경은 필수로 요하게 된다.)
 FROM dt);
 -- 개발자 차원에서 가능한 절차적인 방법
 

--그룹함수는 null값이 있으면


간격의 평균을 구 할 때 값이 섞여 있어도 가능하다. => 집학적인 생각 (그룹함수)

최대 값과 최소값의 간격의 갯수

SELECT MAX(dt), MIN(dt), (MAX(dt) - MIN(dt)) / (COUNT(*)-1) GI --행의 갯수가 아닌 간격의 갯수이기 때문에 -1
FROM dt;
--SQL의 사상에 맞는 쿼리 가장 큰거에서 가장 작은 값을 빼고 간격의 갯수로 나눔







PL/SQL function : java method
정해진 작업을 한다음 결과를 돌려주는 PL/SQL block
문법
CREATE [OR REPLACE] FUNCTION 함수명 ([파라미터]) RETURN TYPE IS --OR REPLACE를 안써도 되지만 중복되는 함수명이 오면 에러가 나서 사용함
BEGIN
END;
/
RETURN TYPE 명시할 때 SIZE 정보는 명시하지 않음
VARCHAR2(2000) X ==> VARCHAR2

사번을 입력받아서(파라미터) 해당 사원원의 이름을 반환하는 함수 getEmpName 생성

CREATE OR REPLACE FUNCTION getEmpName (p_empno emp.empno%TYPE) RETURN VARCHAR2 IS
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename INTO v_ename
    FROM emp
    WHERE empno = p_empno;
    
    RETURN v_ename ;
END;
/
--함수를 만드는 등록하는? 과정
-- Function GETEMPNAME이(가) 컴파일되었습니다.


SELECT empno, ename, getempname(empno)
FROM emp;

function : getdeptname 작성
파라미터 : 부서번호
리턴값 : 파라미터로 들어온 부서번호의 부서이름

SELECT empno, getdeptname(deptno)
FROM emp;

CREATE OR REPLACE FUNCTION getdeptname (p_deptno dept.deptno%TYPE) RETURN VARCHAR2 IS
    v_dname dept.dname%TYPE;
BEGIN
    SELECT dname INTO v_dname
    FROM dept
    WHERE deptno = p_deptno;
    
    RETURN v_dname ;
END;
/

DROP FUNCTION getdeptname;





package 패키지 : ***연관된*** PL/SQL 블럭을 관리하는 객체
가장 대표적인 오라클 내장 패키지 : DBMS_OUTPUT. --함수 일 수 도 있고 프로시져 일 수 도 있다.

package 생성 단계는 2단계로 나누어 생성
1. 선언부          : interface

CREATE OR REPLACE PACKAGE 패키지명 AS
    FUNCTION 함수이름 (인자) RETURN 반환타입;
END 패키지명;
/

2. body(구현부)    : class
CREATE OR REPLACE PACKAGE BODY names AS
    FUNCTION 함수이름 (인자) RETURN 반환타입 IS
        --선언부
    BEGIN
        --실행부
        RETURN
    END;
END;
/

getempname, getdeptname
names라는 이름의 패키지를 생성하여 등록

1. 패키지 선언부 생성
CREATE OR REPLACE PACKAGE names AS
    FUNCTION getempname (p_empno emp.empno%TYPE) RETURN VARCHAR2;
    FUNCTION getdeptname (p_deptno dept.deptno%TYPE) RETURN VARCHAR2;
END names;
/
--java로 치면 인터페이스를 생성한것

2. 패키지 바디 생성
CREATE OR REPLACE PACKAGE BODY names AS
    FUNCTION getEmpName (p_empno emp.empno%TYPE) RETURN VARCHAR2 IS --CREATE OR REPLACE 는 기술하지 않는다. FUNCTION으로 시작
        v_ename emp.ename%TYPE;
    BEGIN
        SELECT ename INTO v_ename
        FROM emp
        WHERE empno = p_empno;
    
        RETURN v_ename ;
END;    
    FUNCTION getdeptname (p_deptno dept.deptno%TYPE) RETURN VARCHAR2 IS
        v_dname dept.dname%TYPE;
    BEGIN
        SELECT dname INTO v_dname
        FROM dept
        WHERE deptno = p_deptno;
    
        RETURN v_dname ;
    END;
END;
/

SELECT NAMES.GETDEPTNAME(deptno)
FROM emp;

-- 패키지의 의미있는 부분은 연관된걸 모아놓는 개념 때문 변경되면 다같이 변경되므로 관리에 유리 / 패키지를 안쓰는 경우도 많음 보기가 힘들어서
-- 기능적 의미 x


TRIGGER : 방아쇠

이벤트 핸들러 : 이벤트를 다루는 녀석

web : 클릭, 스크롤링, 키입력
dbms : 특정 테이블에 데이터 신규입력, 기존 데이터 변경, 기존 데이터 삭제
      ==> 후속작업
      
트리거 : 설정한 이벤트에 따라 자동으로 실행되는 PL/SQL 블럭
        이벤트 종류 : 데이터 신규입력, 기존 데이터 삭제, 기존 데이터 변경
        
시나리오 : users 테이블의 pass 컬럼(비밀번호)이 존재
          특정 쿼리에 의해 users테이블의 pass 컬럼이 변경이 되면
          users_history 테이블에 변경전 pass 값을 트리거를 통해 저장
       
1. users_history 테이블 생성          
CREATE TABLE users_history AS
    SELECT userid, pass, sysdate reg_dt
    FROM users
    WHERE 1=2;

users 테이블의 변경을 감지하여 실행할 트리거를 생성
감지 항목 : users 테이블의 정보가 pass 컬럼이 변경이 되었을 때
감지시 실행 로직 : 변경전 pass 값을 users_history에 저장

CREATE OR REPLACE TRIGGER make_history
    BEFORE UPDATE ON users
    FOR EACH ROW
    --PL/SQL 선언부
    
    BEGIN
        /* users 테이블의 특정 행이 update가 되었을 경우 실행
        :OLD.컬럼명 ==> 기존 값
        :NEW.컬럼명 ==> 갱신 값 */
        IF :OLD.pass != :NEW.pass THEN
            INSERT INTO users_history VALUES (:OLD.userid, :OLD.pass, SYSDATE);
    END IF;
END;
/
    
SELECT *
FROM users;

트리거와 무관한 컬럼을 변경할 시 테스트
UPDATE users SET usernm = 'brown'
WHERE userid = 'brown';

SELECT *
FROM users_history;

트리거와 관련된 컬럼을 변경할 시 테스트
UPDATE users SET pass = '1234'
WHERE userid = 'brown';

SELECT *
FROM users_history;


DESC users_history;    


신규개발 : 빨리 개발 하는 것이 가능 좋아함
유지보수 : 유지보수적인 면에서는 문서화가 잘 안되어 있을 경우 코드 동작에 대한 이해가 힘들어 짐 안좋아함






예외 : EXCEPTION
    java : exception, error
            - checked exception : 반드시 예외처리를 해야하는 예외
            - unchecked exception : 예외처리를 안해도 되는 예외
PL/SQL : PL/SQL 블럭이 실행되는 동안 발생한 에러
예외의 종류
1. 사전 정의 예외 (predefined oracle exception)
    . java ARITHMATIC EXCEPTION
    . 오라클이 사전에 정의한 상황에서 발생하는 예외
2. 사용자 정의 예외
    . 변수, 커서처럼 PL/SQL 블록의 선언부에 개발자가 직접 선언한 예외
      RAISE 키워드를 통해 개발자가 직접 예외를 던진다.
      (JAVA : throw new RuntimeException();)
      
PL/SQL 블록에서 예외가 발생하면...
예외가 발생한 지점에서 코드 중단(에러)
단, PL/SQL 블록에서 예외처리 부분이 존재하면 (EXCEPTION 절)
EXCEPTION 절에 기술한 코드가 실행