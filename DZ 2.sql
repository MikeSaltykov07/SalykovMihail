--DZ 2
--1) Однотабличные запросы
--1. Вывести несколькими способами все имена и фамилии студентов, средний балл которых от 3 до 4.
--1.1
SELECT s.Name, s.Surname
FROM STUDENTS s
WHERE Score >3 AND Score<=4
--1.2
SELECT s.Name, s.Surname
FROM STUDENTS s
WHERE Score BETWEEN 3 AND 4
--2. Вывести несколькими способами всех студентов заданного курса
--2.1
SELECT s.Name, s.Surname
FROM STUDENTS s
WHERE N_GROUP = :N_GROUP
--2.2
SELECT s.Name, s.Surname
FROM STUDENTS s
WHERE N_GROUP = 2282;
--3. Познакомиться с функцией to_char. При помощи неё вывести студентов, которые родились в 21 веке
SELECT s.Name, s.Surname
FROM STUDENTS s
WHERE to_char(DATE_BIRTH, 'YYYY') > 2000;
--4. Аналогично п.3 вывести всех студентов, которые родились в заданном месяце
SELECT s.Name, s.Surname
FROM STUDENTS s
WHERE to_char(DATE_BIRTH, 'MM') = :DATE_BIRTH;
--5. Познакомиться с функцией sysdate. Вывести всех студентов, которые родились в текущем месяце
SELECT s.Name, s.Surname
FROM STUDENTS s
WHERE to_char(DATE_BIRTH, 'MM') = TO_CHAR(SYSDATE, 'MM');
--6. Вывести всех студентов и отсортировать по номеру группы
SELECT s.Name, s.Surname
FROM STUDENTS s
ORDER BY N_GROUP ASC;
--7. Вывести всех студентов и отсортировать по номеру группы, внутри каждой группы отсортировать по фамилии от а до я
SELECT s.Name, s.Surname
FROM STUDENTS s
ORDER BY N_GROUP,
         SURNAME ASC;
--8. Вывести студентов, средний балл которых больше 4 и отсортировать по баллу от большего к меньшему
SELECT s.Name, s.Surname
FROM STUDENTS s
WHERE s.Score > 4
ORDER BY s.Score ASC;
--9. Из запроса №8 вывести несколькими способами на экран только 5 студентов с максимальным баллом
--9.1
SELECT *
from 
   (SELECT s.Name, s.Surname, s.Score
   FROM students s
   ORDER BY s.Score DESC)
WHERE rownum <= 5;
--9.2
SELECT s.Name, s.Surname, s.Score
from students s
ORDER BY s.Score DESC FETCH FIRST 5 ROWS ONLY
--10. Выведите хобби и с использованием условного оператора сделайте риск словами:
SELECT h.Name, h.RISK,
 CASE
  WHEN h.RISK<2 THEN 'очень низкий'
  WHEN h.RISK>=2 AND h.RISK<4 THEN 'низкий'
  WHEN h.RISK>=4 AND h.RISK<6 THEN 'средний'
  WHEN h.RISK>=6 AND h.RISK<8 THEN 'высокий'
  WHEN h.RISK>=8 THEN 'очень высокий'
 END
FROM HOBBIES h;
--11. Искать студентов по городу проживания. 
SELECT s.Name, s.Surname, s.Address
FROM STUDENTS s
WHERE s.Address LIKE 'г. Дубна%';
--2) Групповые функции
--1. Выведите на экран номера групп и количество студентов, обучающихся в них
SELECT N_GROUP,
       COUNT(N_GROUP) AS COUNT_STUDENTS --С "количество_студентов" НЕ работает
FROM STUDENTS
GROUP BY N_GROUP
ORDER BY N_GROUP DESC;
--2. Выведите на экран для каждой группы максимальный средний балл
SELECT N_GROUP,
       AVG(SCORE) AS AVG_GROUP
FROM STUDENTS
GROUP BY N_GROUP
ORDER BY N_GROUP;
--3. Подсчитать количество студентов с каждой фамилией
SELECT SURNAME,
       COUNT(SURNAME) AS COUNT_SURNAME
FROM STUDENTS
GROUP BY SURNAME
ORDER BY SURNAME;
--4. Подсчитать студентов, которые родились в каждом году ???
--можно группировать не только по конкретному атрибуту, но и по атрибуту с использованием функции
SELECT to_char(DATE_BIRTH, 'YYYY'),
       COUNT(to_char(DATE_BIRTH, 'YYYY'))
FROM STUDENTS
GROUP BY DATE_BIRTH
--5. Для студентов каждого курса подсчитать средний балл
SELECT substr(n_group,1,1) as N_Kursa,
       AVG(SCORE)
FROM STUDENTS
group by substr(n_group,1,1)
--6. Для студентов заданного курса вывести один номер групп с максимальным средним баллом
SELECT N_GROUP,
       MAX(SCORE) AS MAX
FROM STUDENTS
GROUP BY N_GROUP
ORDER BY MAX(SCORE) DESC FETCH FIRST 1 ROWS ONLY
--7. Для каждой группы подсчитать средний балл, вывести на экран только те номера групп и их средний балл, 
--      в которых он менее или равен 3.5. Отсортировать по от меньшего среднего балла к большему.
SELECT N_GROUP,
       AVG(SCORE) AS AVG_Group
FROM STUDENTS
GROUP BY N_GROUP 
HAVING AVG(SCORE) >= 3.5
Order by AVG(SCORE) ASC;
--8. Вывести 3 хобби с максимальным риском
SELECT NAME,
       MAX(RISK) AS MAX
FROM HOBBIES
GROUP BY NAME
ORDER BY MAX(RISK) DESC FETCH FIRST 3 ROWS ONLY
--9. Для каждой группы в одном запросе вывести количество студентов, максимальный балл в группе, 
--      средний балл в группе, минимальный балл в группе
SELECT N_GROUP,
       COUNT(N_GROUP) AS Sum_Student,
       MAX(SCORE) as MAX_score,
       AVG(SCORE) as AVG_score,
       MIN(SCORE) as MIN_score
FROM students
GROUP BY N_GROUP
--10. Вывести студента/ов, который/ые имеют наибольший балл в заданной группе
SELECT NAME,
       SURNAME,
       SCORE
FROM STUDENTS
WHERE N_GROUP = :N_GROUP
ORDER BY SCORE DESC FETCH FIRST 1 ROWS ONLY;
--11. Аналогично 10 заданию, но вывести в одном запросе для каждой группы студента с максимальным баллом.
SELECT *
FROM ( SELECT N_GROUP,
              NAME,
              MAX(SCORE) as MAX_score
       FROM STUDENTS
       GROUP BY N_GROUP, 
	            NAME
     )
WHERE MAX_score = (SELECT SCORE FROM STUDENTS ORDER BY SCORE DESC FETCH FIRST 1 ROWS ONLY) 
--3) Многотабличные запросы
--1. Вывести все имена и фамилии студентов, и название хобби, которым занимается этот студент.
SELECT s.NAME,
       s.SURNAME,
       h.NAME AS HOBBIE_NAME
FROM STUDENTS s,
     STUDENTS_HOBBIES s_h,
     HOBBIES h
WHERE s.N_Z = s_h.N_Z AND
      s_h.HOBBY_ID = h.ID;
--2. Вывести информацию о студенте, занимающимся хобби самое продолжительное время.
select *
from
(SELECT s.NAME,
       s.SURNAME,
       s_h.DATE_START,
 CASE
  WHEN s_h.DATE_FINISH IS NULL THEN sysdate - s_h.DATE_START
  WHEN s_h.DATE_FINISH IS NOT NULL THEN s_h.DATE_FINISH - s_h.DATE_START
 END as days
FROM STUDENTS s,
     STUDENTS_HOBBIES s_h
WHERE s.N_Z = s_h.N_Z)
where days = (
 SELECT 
  CASE
   WHEN s_h.DATE_FINISH IS NOT NULL THEN s_h.date_finish - s_h.date_start
   WHEN s_h.DATE_FINISH IS NULL THEN sysdate - s_h.date_start
  END as days 
 FROM STUDENTS_HOBBIES s_h
 ORDER BY days DESC FETCH FIRST 1 ROWS ONLY)
--3. Вывести имя, фамилию, номер зачетки и дату рождения для студентов, средний балл которых выше среднего, 
--     а риск всех хобби, которыми он занимается в данный момент больше 0.9.
SELECT s.N_Z,
       s.NAME,
       s.SURNAME,
       s.DATE_BIRTH,
       s_r.sum_risk 
FROM STUDENTS s
INNER JOIN ( 
SELECT S_H.N_Z,
       SUM(RISK) as sum_risk
FROM STUDENTS s,
     STUDENTS_HOBBIES s_h,
     HOBBIES h
WHERE s.N_Z = s_h.N_Z AND
      s_h.HOBBY_ID = h.ID AND
      s_h.DATE_FINISH IS NULL 
GROUP BY S_H.N_Z
ORDER BY S_H.N_Z
) s_r on s_r.n_z = s.n_z
where S.SCORE >= (SELECT AVG(SCORE) FROM STUDENTS) AND
      s_r.sum_risk >= 9
--4. Вывести фамилию, имя, зачетку, дату рождения, название хобби и длительность в месяцах, для всех завершенных хобби.
SELECT s.N_Z,
       s.NAME,
       s.SURNAME,
       h.NAME,
       MONTHS_BETWEEN(s_h.DATE_FINISH, s_h.DATE_START) as  month
FROM STUDENTS s,
     STUDENTS_HOBBIES s_h,
     HOBBIES h
WHERE s.N_Z = s_h.N_Z AND
      s_h.HOBBY_ID = h.ID AND
      s_h.DATE_FINISH IS NOT NULL
--5. Вывести фамилию, имя, зачетку, дату рождения студентов, которым исполнилось N полных лет на текущую дату, 
--    и которые имеют более 1 действующего хобби.
SELECT s.N_Z,
       s.NAME,
       s.SURNAME,
       to_char(sysdate, 'YYYY') - to_char(DATE_BIRTH, 'YYYY') as years
FROM STUDENTS s,
     STUDENTS_HOBBIES s_h
WHERE s.N_Z = s_h.N_Z AND
      s_h.HOBBY_ID IS NOT NULL AND
      to_char(sysdate, 'YYYY') - to_char(DATE_BIRTH, 'YYYY') >= :YEARS
ORDER BY S.N_Z;
--6. Найти средний балл в каждой группе, учитывая только баллы студентов, которые имеют хотя бы одно действующее хобби.
SELECT s.N_GROUP, 
       AVG(s.SCORE) as AVG_score
FROM STUDENTS s,
     STUDENTS_HOBBIES s_h
WHERE s.N_Z = s_h.N_Z AND
      S_H.DATE_FINISH IS NOT NULL
GROUP BY s.N_GROUP 
--7. Найти название, риск, длительность в месяцах самого продолжительного хобби из действующих, 
--    указав номер зачетки студента и номер его группы.
SELECT s.N_Z,
       s.N_GROUP,
       h.NAME,
       h.RISK,
       MAX(MONTHS_BETWEEN(s_h.DATE_FINISH, s_h.DATE_START)) as MAX_month
FROM STUDENTS s,
     STUDENTS_HOBBIES s_h,
     HOBBIES h
WHERE s.N_Z = s_h.N_Z AND
      s_h.HOBBY_ID = h.ID AND
      s_h.DATE_FINISH IS NOT NULL
GROUP BY s.N_Z,
       s.N_GROUP,
       h.NAME,
       h.RISK;
--8. Найти все хобби, которыми увлекаются студенты, имеющие максимальный балл.
SELECT s.N_Z,
       h.NAME
FROM STUDENTS s,
     STUDENTS_HOBBIES s_h,
     HOBBIES h
WHERE s.N_Z = s_h.N_Z AND
      s_h.HOBBY_ID = h.ID AND
      s.SCORE = ( SELECT MAX(SCORE) 
                  FROM STUDENTS )
--9. Найти все действующие хобби, которыми увлекаются троечники 2-го курса.
SELECT h.NAME,
       s.N_GROUP,
       s.SCORE
FROM STUDENTS s,
     STUDENTS_HOBBIES s_h,
     HOBBIES h
WHERE s.N_Z = s_h.N_Z AND
      s_h.HOBBY_ID = h.ID AND
      s_h.DATE_FINISH IS NULL AND
      s.SCORE BETWEEN 2.5 AND 3.5 AND
	  s_h.DATE_FINISH IS NOT NULL
      s.N_GROUP like '2%';
--10. Найти номера курсов, на которых более 50% студентов имеют более одного действующего хобби.
SELECT T1.COURSE
FROM (
SELECT SUBSTR(S.N_GROUP,1,1) AS COURSE,
       COUNT(DISTINCT S.N_Z) AS SN
FROM STUDENTS s,
     STUDENTS_HOBBIES s_h
WHERE s.N_Z = s_h.N_Z AND
      S_H.DATE_FINISH IS NULL
GROUP BY SUBSTR(S.N_GROUP,1,1)
) T1
INNER JOIN(
SELECT SUBSTR(S.N_GROUP,1,1) AS COURSE,
       COUNT(S.N_Z) SC
FROM STUDENTS S
GROUP BY SUBSTR(S.N_GROUP,1,1)
) T2 ON T2.COURSE = T1.COURSE
WHERE T1.SN/T2.SC > 0.5
--11. Вывести номера групп, в которых не менее 60% студентов имеют балл не ниже 4.
SELECT T1.N_GROUP
FROM ( 
SELECT N_GROUP,
       COUNT(N_Z)  COUNT --почему as можно пропускать?
FROM STUDENTS
WHERE SCORE >=4
GROUP BY N_GROUP
ORDER BY N_GROUP
) T1
INNER JOIN(
SELECT N_GROUP,
       COUNT(N_GROUP)  COUNT
FROM STUDENTS
GROUP BY N_GROUP
ORDER BY N_GROUP
) T2 ON T2.N_GROUP= T1.N_GROUP
WHERE T1.COUNT/T2.COUNT > 0.6
--12. Для каждого курса подсчитать количество различных действующих хобби на курсе.
SELECT SUBSTR(S.N_GROUP,1,1),
        COUNT(DISTINCT H.NAME)
FROM STUDENTS s,
     STUDENTS_HOBBIES s_h,
     HOBBIES h
WHERE s.N_Z = s_h.N_Z AND
      s_h.HOBBY_ID = h.ID AND
      s_h.DATE_FINISH IS NULL
GROUP BY SUBSTR(S.N_GROUP,1,1)
--13. Вывести номер зачётки, фамилию и имя, дату рождения и номер курса для всех отличников, не имеющих хобби. 
--     Отсортировать данные по возрастанию в пределах курса по убыванию даты рождения.
SELECT S.N_Z,
       S.NAME,
       S.SURNAME,
       S.DATE_BIRTH,
       SUBSTR(S.N_GROUP,1,1) COURSE
FROM STUDENTS s,
     STUDENTS_HOBBIES s_h
WHERE s.N_Z = s_h.N_Z AND
      S.SCORE BETWEEN 4.5 AND 5 AND
      s_h.DATE_FINISH IS NOT NULL
ORDER BY COURSE,
         DATE_BIRTH DESC

	-- тут нет смысла подзапрос делать. Order by выполняется уже после select, поэтому переименование сработает
	-- по сортировке: там по умолчанию 10 строк выводит, может не влезло на экран? :D (можно поменять слева сверху Rows)

--14.Создать представление, в котором отображается вся информация о студентах, 
--    которые продолжают заниматься хобби в данный момент и занимаются им как минимум 5 лет.
CREATE VIEW STUDENTS_HOBBIE AS
 SELECT S.*
 FROM STUDENTS s,
     STUDENTS_HOBBIES s_h
 WHERE s.N_Z = s_h.N_Z AND
       s_h.DATE_FINISH IS NULL AND
       TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(S_H.DATE_START, 'YYYY') > 5 -- 01.01.2019 и 31.01.2013. 
       -- Для разницы в годах лучше использовать month_between, а кол-во месяцев в году известно
WITH CHECK OPTION;
--15. Для каждого хобби вывести количество людей, которые им занимаются.

-- Слишком усложнил)
-- Нам надо вывести хобби и количество людей

Select H.NAME,
       count(*) as count_hobbies
FROM HOBBIES H
INNER JOIN STUDENTS_HOBBIES S_H on H.id = S_H.HOBBY_ID
GROUP BY H.NAME -- Всё )

SELECT H.NAME, 
       H_C.COUNT AS STUDENTS_COUNT
FROM (
SELECT S_H.HOBBY_ID ID, 
       COUNT(s.N_Z) COUNT
FROM STUDENTS_HOBBIES s_h,
     STUDENTS s
WHERE s_H.N_Z = s.N_Z 
GROUP BY S_H.HOBBY_ID
ORDER BY S_H.HOBBY_ID
) H_C
INNER JOIN HOBBIES H ON H.ID = H_C.ID;
--16. Вывести ИД самого популярного хобби.

-- Опять усложнено(

SELECT s_h.hobby_id
FROM STUDENTS_HOBBIES s_h
GROUP BY s_h.hobby_id
HAVING count(*) = (SELECT max(count(*)) from STUDENTS_HOBBIES$ s_h group by s_h.hobby_id)

SELECT H.NAME
FROM (
SELECT S_H.HOBBY_ID ID, 
       COUNT(s.N_Z) COUNT
FROM STUDENTS_HOBBIES s_h,
     STUDENTS s
WHERE s_H.N_Z = s.N_Z 
GROUP BY S_H.HOBBY_ID
ORDER BY S_H.HOBBY_ID
) H_C
INNER JOIN HOBBIES H ON H.ID = H_C.ID
WHERE H_C.COUNT = (
SELECT COUNT(s.N_Z)
FROM STUDENTS_HOBBIES s_h,
     STUDENTS s
WHERE s_H.N_Z = s.N_Z 
GROUP BY S_H.HOBBY_ID
 ORDER BY COUNT(s.N_Z) DESC FETCH FIRST 1 ROWS ONLY
)
--17. Вывести всю информацию о студентах, занимающихся самым популярным хобби.

-- Ок, но от 1 вложенности точно можно избавиться

SELECT S.*
FROM STUDENTS S
INNER JOIN (
SELECT P_H.HOBBY_ID,
       S_H.N_Z 
FROM (
SELECT S_H.HOBBY_ID,
       COUNT(s.N_Z)
FROM STUDENTS_HOBBIES s_h,
     STUDENTS s
WHERE s_H.N_Z = s.N_Z 
GROUP BY S_H.HOBBY_ID
HAVING COUNT(S.N_Z) = (
SELECT COUNT(s.N_Z)
FROM STUDENTS_HOBBIES s_h,
     STUDENTS s
WHERE s_H.N_Z = s.N_Z 
GROUP BY S_H.HOBBY_ID
 ORDER BY COUNT(s.N_Z) DESC FETCH FIRST 1 ROWS ONLY
) --условие
) P_H
INNER JOIN STUDENTS_HOBBIES S_H ON S_H.HOBBY_ID = P_H.HOBBY_ID
WHERE s_h.DATE_FINISH IS NULL
ORDER BY S_H.N_Z 
) H_Z ON H_Z.N_Z = S.N_Z

--18. Вывести ИД 3х хобби с максимальным риском.

-- тут же запрос на 1 таблицу без соединений( поправь
SELECT H.ID
FROM HOBBIES H
INNER JOIN (
SELECT H.ID,
       H.RISK
FROM HOBBIES H
 ORDER BY H.RISK DESC FETCH FIRST 3 ROWS ONLY
) M_R ON M_R.ID = H.ID

--19. Вывести 10 студентов, которые занимаются одним (или несколькими) хобби самое продолжительно время.

-- max можно так использовать
-- else - поприятнее выглядеть будет :D


SELECT S.*
FROM STUDENTS S
INNER JOIN
  (SELECT D_N.N_Z,
          D_N.DAYS
   FROM
     (SELECT DISTINCT N_Z,
                         max(CASE
                             WHEN s_h.DATE_FINISH IS NULL THEN sysdate - s_h.DATE_START
                             ELSE s_h.DATE_FINISH - s_h.DATE_START
                         END) DAYS
         FROM STUDENTS_HOBBIES S_H
         ORDER BY N_Z
      ORDER BY D.N_Z) D_N
   INNER JOIN
     (SELECT DISTINCT CASE
                          WHEN s_h.DATE_FINISH IS NULL THEN sysdate - s_h.DATE_START
                          ELSE s_h.DATE_FINISH - s_h.DATE_START
                      END DAYS
      FROM STUDENTS_HOBBIES S_H
      ORDER BY DAYS DESC FETCH FIRST 10 ROWS ONLY) D ON D.DAYS = D_N.DAYS
   ORDER BY D.DAYS DESC FETCH FIRST 10 ROWS ONLY) N ON N.N_Z = S.N_Z
ORDER BY S.N_Z

--20. Вывести номера групп (без повторений), 
--     в которых учатся студенты из предыдущего запроса.

-- лучше сделать предыдущий представлением и используй её

SELECT DISTINCT S.N_GROUP
FROM (
SELECT S.*
FROM STUDENTS S
INNER JOIN (
SELECT D_N.N_Z, D_N.DAYS
FROM (
SELECT D.N_Z,
       MAX(D.DAYS) AS DAYS
FROM (
SELECT DISTINCT N_Z,
 CASE
  WHEN s_h.DATE_FINISH IS NULL THEN sysdate - s_h.DATE_START
  WHEN s_h.DATE_FINISH IS NOT NULL THEN s_h.DATE_FINISH - s_h.DATE_START
 END DAYS
FROM STUDENTS_HOBBIES S_H
ORDER BY N_Z
) D 
GROUP BY D.N_Z
ORDER BY D.N_Z
) D_N
INNER JOIN ( 
SELECT DISTINCT
 CASE
  WHEN s_h.DATE_FINISH IS NULL THEN sysdate - s_h.DATE_START
  WHEN s_h.DATE_FINISH IS NOT NULL THEN s_h.DATE_FINISH - s_h.DATE_START
 END DAYS
FROM STUDENTS_HOBBIES S_H
ORDER BY DAYS DESC FETCH FIRST 10 ROWS ONLY
) D ON D.DAYS = D_N.DAYS
ORDER BY D.DAYS DESC FETCH FIRST 10 ROWS ONLY
) N ON N.N_Z = S.N_Z
ORDER BY S.N_Z
) S

--21. Создать представление, которое выводит номер зачетки, 
--     имя и фамилию студентов, отсортированных по убыванию среднего балла.

-- эм, зачем вложенность?

CREATE VIEW STUDENT AS
 SELECT *
 FROM (
 SELECT N_Z, NAME, SURNAME
 FROM STUDENTS
 ORDER BY SCORE ASC
 )
WITH CHECK OPTION;
--22. Представление: найти каждое популярное хобби на каждом курсе.

-- проверить позже(22-25)

CREATE VIEW CURSE_HOBBY_TOP AS
SELECT *
FROM (
SELECT TT1.CURSE,
       H.NAME HOBBY_TOP
FROM (
SELECT CURSE,
       COUNT(CURSE) COUNT,
       HOBBY_ID
FROM (
SELECT SUBSTR(S.N_GROUP,1,1) CURSE,
       S_H.HOBBY_ID HOBBY_ID
FROM STUDENTS S
INNER JOIN STUDENTS_HOBBIES S_H ON s_H.N_Z = s.N_Z 
) T1
GROUP BY HOBBY_ID, CURSE
ORDER BY CURSE
) TT1

INNER JOIN (
SELECT CURSE,
       MAX(COUNT) MAX
FROM (
SELECT CURSE,
       COUNT(CURSE) COUNT,
       HOBBY_ID
FROM (
SELECT SUBSTR(S.N_GROUP,1,1) CURSE,
       S_H.HOBBY_ID HOBBY_ID
FROM STUDENTS S
INNER JOIN STUDENTS_HOBBIES S_H ON s_H.N_Z = s.N_Z 
) T1
GROUP BY HOBBY_ID, CURSE
ORDER BY CURSE
) T2
GROUP BY CURSE
) TT2 ON TT2.MAX = TT1.COUNT
INNER JOIN HOBBIES H ON H.ID = TT1.HOBBY_ID
ORDER BY CURSE
) TTT3
WITH CHECK OPTION;

--23. Представление: найти хобби с максимальным риском среди 
--      самых популярных хобби на 2 курсе.
CREATE  VIEW RISK_HOBBY_CURSE_2 AS
SELECT *
FROM (
SELECT H.NAME TOP_HOBBY_CURSE_2 
FROM HOBBIES H
INNER JOIN (
SELECT TT1.HOBBY_ID ID
FROM (
SELECT CURSE,
       COUNT(CURSE) COUNT,
       HOBBY_ID
FROM (
SELECT SUBSTR(S.N_GROUP,1,1) CURSE,
       S_H.HOBBY_ID HOBBY_ID
FROM STUDENTS S
INNER JOIN STUDENTS_HOBBIES S_H ON s_H.N_Z = s.N_Z 
) T1
GROUP BY HOBBY_ID, CURSE
HAVING CURSE = 2
ORDER BY HOBBY_ID
) TT1
WHERE TT1.COUNT = (
SELECT COUNT(s.N_Z)
FROM STUDENTS_HOBBIES s_h,
     STUDENTS s
WHERE s_H.N_Z = s.N_Z 
GROUP BY S_H.HOBBY_ID
 ORDER BY COUNT(s.N_Z) DESC FETCH FIRST 1 ROWS ONLY
)
) TTT1 ON TTT1.ID = H.ID
 ORDER BY H.RISK DESC FETCH FIRST 1 ROWS ONLY
) TTTT1
WITH CHECK OPTION;
--24. Представление: для каждого курса подсчитать количество 
--      студентов на курсе и количество отличников.
CREATE VIEW CURSE_COUNT_EXC AS
SELECT *
FROM (
SELECT TT1.*,
       TT2.COUNT_EXC
FROM (
SELECT CURSE,
       COUNT(N_Z) COUNT
FROM (
SELECT SUBSTR(S.N_GROUP,1,1) CURSE,
       S.N_Z
FROM STUDENTS S
) T1
GROUP BY CURSE
) TT1
INNER JOIN (
SELECT CURSE,
       COUNT(SCORE) COUNT_EXC
FROM (
SELECT SUBSTR(S.N_GROUP,1,1) CURSE,
       S.SCORE
FROM STUDENTS S
WHERE SCORE BETWEEN 4.5 AND 5
) T2
GROUP BY CURSE
) TT2 ON TT2.CURSE = TT1.CURSE
) TTT1
WITH CHECK OPTION;
--25. Представление: самое популярное хобби среди всех студентов.
CREATE VIEW MOST_POP_HOBBY AS
SELECT *
FROM (
SELECT H.NAME HOBBY
FROM HOBBIES H
INNER JOIN (
SELECT S_H.HOBBY_ID ID,
       COUNT(s.N_Z) COUNT
FROM STUDENTS_HOBBIES s_h,
     STUDENTS s
WHERE s_H.N_Z = s.N_Z 
GROUP BY S_H.HOBBY_ID
HAVING COUNT(S.N_Z) = (
SELECT COUNT(s.N_Z)
FROM STUDENTS_HOBBIES s_h,
     STUDENTS s
WHERE s_H.N_Z = s.N_Z 
GROUP BY S_H.HOBBY_ID
 ORDER BY COUNT(s.N_Z) DESC FETCH FIRST 1 ROWS ONLY
) --условие
 ORDER BY COUNT DESC FETCH FIRST 1 ROWS ONLY
) T1 ON T1.ID = H.ID
) TT1
WITH CHECK OPTION;
--26. Создать обновляемое представление. +
CREATE OR REPLACE VIEW S AS
SELECT N_Z, NAME
FROM STUDENTS
WITH CHECK OPTION;
--27. Для каждой буквы алфавита из имени найти максимальный, 
--      средний и минимальный балл. (Т.е. среди всех студентов, 
--      чьё имя начинается на А (Алексей, Алина, Артур, Анджела) 
--      найти то, что указано в задании. Вывести на экран тех, 
--      максимальный балл которых больше 3.6

-- опять, тут спокойно можно без вложенности, не надо так усложнять(

SELECT T2.ABC, MAX(T1.SCORE) MAX, AVG(T1.SCORE) AVG, MIN(T1.SCORE) MIN
FROM (
SELECT SUBSTR(NAME,1,1) ABC, SCORE
FROM STUDENTS
ORDER BY NAME
) T1
INNER JOIN (
SELECT DISTINCT  SUBSTR(NAME,1,1) ABC
FROM STUDENTS
ORDER BY ABC
) T2 ON T2.ABC = T1.ABC
GROUP BY T2.ABC
HAVING MAX(T1.SCORE) > 3.6
ORDER BY T2.ABC

--28. Для каждой фамилии на курсе вывести максимальный и минимальный 
--     средний балл. (Например, в университете учатся 4 Иванова 
--     (1-2-3-4). 1-2-3 учатся на 2 курсе и имеют средний балл 
--      4.1, 4, 3.8 соответственно, а 4 Иванов учится на 3 курсе и 
--      имеет балл 4.5. На экране должно быть следующее: 2 Иванов 
--      4.1 3.8 3 Иванов 4.5 4.5

-- аналогично 27, тут только меняется группировка

SELECT T1.*
FROM (
SELECT CURSE, SURNAME, MAX(SCORE), MIN(SCORE)
FROM (
SELECT SUBSTR(N_GROUP,1,1) CURSE, SURNAME, SCORE
FROM STUDENTS
) T1
GROUP BY CURSE, SURNAME
) T1
INNER JOIN (
SELECT DISTINCT SUBSTR(N_GROUP,1,1) CURSE
FROM STUDENTS
) T2 ON T2. CURSE = T1.CURSE

--29. Для каждого года рождения подсчитать количество хобби, 
--     которыми занимаются или занимались студенты.

-- тебя сильно переклинило на вложенности после прошлой пары :D
-- ну ничо, упростить)

SELECT T1.YEAR, COUNT(T1.HOBBY_ID) COUNT_HOBBIES
FROM (
SELECT TO_CHAR(DATE_BIRTH, 'YYYY') YEAR, T.HOBBY_ID
FROM STUDENTS S
INNER JOIN (
SELECT S_H.N_Z, MAX(S_H.HOBBY_ID) HOBBY_ID
FROM STUDENTS_HOBBIES S_H
INNER JOIN (
SELECT DISTINCT N_Z, HOBBY_ID
FROM STUDENTS_HOBBIES
) S ON S. N_Z = S_H.N_Z
GROUP BY S_H.N_Z
ORDER BY S_H.N_Z
) T ON T.N_Z = S.N_Z
) T1
INNER JOIN (
SELECT DISTINCT TO_CHAR(DATE_BIRTH, 'YYYY') YEAR
FROM STUDENTS S
ORDER BY YEAR
) T2 ON T2.YEAR = T1.YEAR
GROUP BY T1.YEAR
ORDER BY T1.YEAR
--30. Для каждой буквы алфавита в имени найти максимальный и 
--     минимальный риск хобби.
SELECT T1.ABC, MAX(T1.RISK) MAX_RISK, MIN(T1.RISK) MIN_RISK
FROM (
SELECT SUBSTR(S.NAME,1,1) ABC, H.RISK RISK
FROM STUDENTS S
INNER JOIN STUDENTS_HOBBIES S_H ON S.N_Z = S_H.N_Z
INNER JOIN HOBBIES H ON H.ID = S_H.HOBBY_ID
ORDER BY ABC
) T1
INNER JOIN (
SELECT DISTINCT SUBSTR(S.NAME,1,1) ABC
FROM STUDENTS S
ORDER BY ABC
) T2 ON T2. ABC = T1.ABC
GROUP BY T1.ABC
ORDER BY T1.ABC





























