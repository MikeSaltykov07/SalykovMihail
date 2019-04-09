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
--15. ++ Для каждого хобби вывести количество людей, которые им занимаются.

Select H.NAME,
       count(*) as count_hobbies
FROM HOBBIES H
INNER JOIN STUDENTS_HOBBIES S_H on H.id = S_H.HOBBY_ID
GROUP BY S_H.HOBBY_ID, H.NAME

--16. ++ Вывести ИД самого популярного хобби.

SELECT s_h.hobby_id
FROM STUDENTS_HOBBIES s_h
GROUP BY s_h.hobby_id
HAVING count(*) = (SELECT max(count(*)) from STUDENTS_HOBBIES$ s_h group by s_h.hobby_id)

--17. ++ Вывести всю информацию о студентах, занимающихся самым популярным хобби.

SELECT S.*
FROM STUDENTS S
INNER JOIN (
SELECT P_H.HOBBY_ID,
       S_H.N_Z 
FROM (
SELECT S_H.HOBBY_ID,
       COUNT(*)
FROM STUDENTS_HOBBIES s_h
GROUP BY S_H.HOBBY_ID
HAVING COUNT(*) = (
SELECT COUNT(*)
FROM STUDENTS_HOBBIES s_h
GROUP BY S_H.HOBBY_ID
 ORDER BY COUNT(*) DESC FETCH FIRST 1 ROWS ONLY
) --условие
) P_H
INNER JOIN STUDENTS_HOBBIES S_H ON S_H.HOBBY_ID = P_H.HOBBY_ID
WHERE s_h.DATE_FINISH IS NULL
ORDER BY S_H.N_Z 
) H_Z ON H_Z.N_Z = S.N_Z

--18. ++ Вывести ИД 3х хобби с максимальным риском.

SELECT H.ID
FROM HOBBIES H
 ORDER BY H.RISK DESC FETCH FIRST 3 ROWS ONLY

--19. ++ Вывести 10 студентов, которые занимаются одним (или несколькими) хобби самое продолжительно время.

SELECT S.*
FROM STUDENTS$ S
INNER JOIN
  (SELECT D_N.N_Z,
          D_N.DAYS
   FROM
     (SELECT N_Z,
                         max(CASE
                             WHEN s_h.DATE_FINISH IS NULL THEN sysdate - s_h.DATE_START
                             ELSE s_h.DATE_FINISH - s_h.DATE_START
                         END) DAYS
         FROM STUDENTS_HOBBIES$ S_H
      GROUP BY N_Z) D_N
   INNER JOIN
     (SELECT DISTINCT CASE
                          WHEN s_h.DATE_FINISH IS NULL THEN sysdate - s_h.DATE_START
                          ELSE s_h.DATE_FINISH - s_h.DATE_START
                      END DAYS
      FROM STUDENTS_HOBBIES$ S_H
      ORDER BY DAYS DESC FETCH FIRST 10 ROWS ONLY) D ON D.DAYS = D_N.DAYS
   ORDER BY D.DAYS DESC FETCH FIRST 10 ROWS ONLY) N ON N.N_Z = S.N_Z
ORDER BY S.N_Z

--20. ++ Вывести номера групп (без повторений), 
--     в которых учатся студенты из предыдущего запроса.

CREATE VIEW N_GR AS
--19

SELECT DISTINCT N_GROUP
FROM N_GR

--21. ++ Создать представление, которое выводит номер зачетки, 
--     имя и фамилию студентов, отсортированных по убыванию среднего балла.

CREATE VIEW STUDENT AS
 SELECT N_Z, NAME, SURNAME
 FROM STUDENTS
 ORDER BY SCORE ASC
WITH CHECK OPTION;
--22. ++ Представление: найти каждое популярное хобби на каждом курсе.

CREATE VIEW CURSE_HOBBY_TOP AS
SELECT *
FROM
  (SELECT TT1.CURSE,
          H.NAME HOBBY_TOP
   FROM
     (SELECT SUBSTR(S.N_GROUP, 1, 1) CURSE,
             COUNT(*) COUNT, S_H.HOBBY_ID HOBBY_ID
       FROM STUDENTS S
       INNER JOIN STUDENTS_HOBBIES S_H ON S_H.N_Z = S.N_Z
       GROUP BY SUBSTR(S.N_GROUP, 1, 1), S_H.HOBBY_ID 
      ORDER BY CURSE) TT1
   INNER JOIN
     (
        SELECT CURSE,
             MAX(COUNT) MAX
        FROM
            (
                SELECT SUBSTR(S.N_GROUP, 1, 1) CURSE,
                    S_H.HOBBY_ID HOBBY_ID, count(*) count
                FROM STUDENTS$ S
                INNER JOIN STUDENTS_HOBBIES$ S_H ON s_H.N_Z = s.N_Z
                GROUP BY HOBBY_ID, SUBSTR(S.N_GROUP, 1, 1)
            ) T2
        GROUP BY CURSE
      ) TT2 ON TT2.MAX = TT1.COUNT
   INNER JOIN HOBBIES$ H ON H.ID = TT1.HOBBY_ID
   ORDER BY CURSE) TTT3

--23. Представление: найти хобби с максимальным риском среди 
--      самых популярных хобби на 2 курсе.

-- на паре обсудим

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
--24. ++ Представление: для каждого курса подсчитать количество 
--      студентов на курсе и количество отличников.


CREATE VIEW CURSE_COUNT_EXC AS
SELECT *
FROM (
SELECT T1.*,
       T2.COUNT_EXC
FROM (
SELECT SUBSTR(N_GROUP,1,1) CURSE,
       COUNT(*) COUNT
FROM STUDENTS$
GROUP BY SUBSTR(N_GROUP,1,1)
) T1
INNER JOIN (
SELECT SUBSTR(N_GROUP,1,1) CURSE,
       COUNT(*) COUNT_EXC
FROM STUDENTS$
WHERE SCORE BETWEEN 4.5 AND 5
GROUP BY SUBSTR(N_GROUP,1,1)
) T2 ON T2.CURSE = T1.CURSE
) T
WITH CHECK OPTION;

--25. ++ Представление: самое популярное хобби среди всех студентов.

CREATE VIEW MOST_POP_HOBBY AS
SELECT *
FROM (
SELECT H.NAME HOBBY
FROM HOBBIES H
INNER JOIN (
SELECT S_H.HOBBY_ID ID,
       COUNT(*) COUNT
FROM STUDENTS_HOBBIES s_h
GROUP BY S_H.HOBBY_ID
HAVING COUNT(*) = (
SELECT COUNT(*)
FROM STUDENTS_HOBBIES s_h
GROUP BY S_H.HOBBY_ID
 ORDER BY COUNT(*) DESC FETCH FIRST 1 ROWS ONLY
) --условие
 ORDER BY COUNT DESC FETCH FIRST 1 ROWS ONLY
) T1 ON T1.ID = H.ID
) TT1
WITH CHECK OPTION;

--26. ++ Создать обновляемое представление.
CREATE OR REPLACE VIEW S AS
SELECT N_Z, NAME
FROM STUDENTS
WITH CHECK OPTION;

--27. ++ Для каждой буквы алфавита из имени найти максимальный, 
--      средний и минимальный балл. (Т.е. среди всех студентов, 
--      чьё имя начинается на А (Алексей, Алина, Артур, Анджела) 
--      найти то, что указано в задании. Вывести на экран тех, 
--      максимальный балл которых больше 3.6

SELECT SUBSTR(NAME,1,1) ABC, MAX(SCORE) MAX, AVG(SCORE) AVG, MIN(SCORE) MIN
FROM STUDENTS S
GROUP BY SUBSTR(NAME,1,1)
HAVING MAX(S.SCORE) > 3.6
ORDER BY SUBSTR(NAME,1,1)

--28. ++ Для каждой фамилии на курсе вывести максимальный и минимальный 
--     средний балл. (Например, в университете учатся 4 Иванова 
--     (1-2-3-4). 1-2-3 учатся на 2 курсе и имеют средний балл 
--      4.1, 4, 3.8 соответственно, а 4 Иванов учится на 3 курсе и 
--      имеет балл 4.5. На экране должно быть следующее: 2 Иванов 
--      4.1 3.8 3 Иванов 4.5 4.5

SELECT SUBSTR(N_GROUP,1,1) CURSE, SURNAME, MAX(SCORE), MIN(SCORE)
FROM STUDENTS
GROUP BY SUBSTR(N_GROUP,1,1), SURNAME
ORDER BY SUBSTR(N_GROUP,1,1)

--29. ++ Для каждого года рождения подсчитать количество хобби, 
--     которыми занимаются или занимались студенты.


SELECT TO_CHAR(DATE_BIRTH, 'YYYY') YEAR, COUNT(DISTINCT S.N_Z)
FROM STUDENTS S
INNER JOIN STUDENTS_HOBBIES S_H ON S_H.N_Z = S.N_Z
GROUP BY TO_CHAR(DATE_BIRTH, 'YYYY')


--30. ++ Для каждой буквы алфавита в имени найти максимальный и 
--     минимальный риск хобби.

SELECT SUBSTR(S.NAME,1,1) ABC, MAX(H.RISK) MAX_RISK, MIN(H.RISK) MIN_RISK
FROM STUDENTS S
INNER JOIN STUDENTS_HOBBIES S_H ON S.N_Z = S_H.N_Z
INNER JOIN HOBBIES H ON H.ID = S_H.HOBBY_ID
GROUP BY SUBSTR(S.NAME,1,1)
ORDER BY SUBSTR(S.NAME,1,1)

--31. ++ Для каждого месяца из даты рождения вывести средний балл 
--     студентов, которые занимаются хобби с названием «Футбол»

SELECT TO_CHAR(S.DATE_BIRTH, 'MM') MM, AVG(S.SCORE)
FROM STUDENTS$ S
INNER JOIN STUDENTS_HOBBIES$ S_H ON S_H.N_Z = S.N_Z 
INNER JOIN HOBBIES$ H ON H.ID = S_H.HOBBY_ID
WHERE TO_CHAR(DATE_BIRTH, 'MM') IS NOT NULL AND
H.NAME = 'Футбол'
GROUP BY TO_CHAR(S.DATE_BIRTH, 'MM')
ORDER BY TO_CHAR(S.DATE_BIRTH, 'MM')

--32. ++ Вывести информацию о студентах, которые занимались или занимаются 
--      хотя бы 1 хобби в следующем формате: 
--      Имя: Иван, фамилия: Иванов, группа: 1234

SELECT S.NAME "Имя" , S.SURNAME "Фамилия", S.N_GROUP "группа"
FROM STUDENTS$ S
INNER JOIN (
SELECT DISTINCT N_Z
FROM STUDENTS_HOBBIES$
) N ON N.N_Z = S.N_Z

--
SELECT NAME "Имя" , SURNAME "Фамилия", N_GROUP "группа"
FROM STUDENTS$
WHERE N_Z IN (
SELECT DISTINCT N_Z
FROM STUDENTS_HOBBIES$)

--33. ++ Найдите в фамилии в каком по счёту символа встречается «ов». 
--     Если 0 (т.е. не встречается, то выведите на экран «не найдено».

-- но тоже можно без подзапроса))
SELECT 
    CASE
       WHEN TO_CHAR(INSTR(SURNAME, 'ов'))= '0' THEN 'Не найдено'
       ELSE TO_CHAR(INSTR(SURNAME, 'ов'))
     END AS NUM
FROM STUDENTS$ 

--
SELECT 
    CASE
       WHEN STR = '0' THEN 'Не найдено'
       ELSE STR
     END AS NUM
FROM (
      SELECT TO_CHAR(INSTR(SURNAME, 'ов')) STR
      FROM STUDENTS$ 
) T

--34. ++ Дополните фамилию справа символом # до 10 символов.
SELECT RPAD(SURNAME, 10, '#')
FROM STUDENTS$

--35. ++ При помощи функции удалите все символы # из предыдущего запроса.
SELECT TRIM('#' FROM R)
FROM (
SELECT RPAD(SURNAME, 10, '#') R
FROM STUDENTS$ ) T

--36. ++ Выведите на экран сколько дней в апреле 2018 года.

SELECT  TO_DATE('01-05-2018') - TO_DATE('01-04-2018') 
FROM DUAL

--37. ++ Выведите на экран какого числа будет ближайшая суббота.
-- SELECT NEXT_DAY(SYSDATE,'Saturday') 
SELECT sysdate + (7 - TO_CHAR(SYSDATE, 'D'))
FROM DUAL

--38. ++ Выведите на экран век, а также какая сейчас 
--       неделя года и день года.

-- век тоже есть -  CC

SELECT TRUNC(TO_CHAR(SYSDATE, 'YYYY')/100)+1 AS "ВЕК", TO_CHAR(SYSDATE, 'WW') AS week_year, TO_CHAR(SYSDATE, 'DDD') AS DAY_YEAR
FROM DUAL

--39. ++ Выведите всех студентов, которые занимались или занимаются хотя 
--      бы 1 хобби. Выведите на экран Имя, Фамилию, Названию хобби, 
--      а также надпись «занимается», если студент продолжает 
--      заниматься хобби в данный момент или «закончил», 
--      если уже не занимает.
SELECT S.NAME, S.SURNAME, H.NAME,
   CASE 
     WHEN S_H.DATE_FINISH IS NOT NULL THEN 'ЗАКОНЧИЛ'
     WHEN S_H.DATE_FINISH IS NULL THEN 'ЗАНИМАЕТСЯ'
   END AS HOBBY  
FROM STUDENTS$ S
INNER JOIN STUDENTS_HOBBIES$ S_H ON S_H.N_Z = S.N_Z 
INNER JOIN HOBBIES$ H ON H.ID = S_H.HOBBY_ID

--40. ++ Для каждой группы вывести сколько студентов учится на 5,4,3,2. 
--      Использовать обычное математическое округление. 
--       Итоговый результат должен выглядеть примерно в таком виде:

SELECT * 
FROM (
SELECT ROUND(SCORE) SCORE, N_GROUP 
FROM STUDENTS$ ) 
PIVOT
( COUNT(N_GROUP)
  FOR N_GROUP IN (4011, 3222, 4032)) -- SELECT не работает, только ручками? Да, только так, т.к. атрибуты должны быть известны
ORDER BY ROUND(SCORE)












--4) Задания на изменение/удаление/добавление
--1. ++ Удалите всех студентов с неуказанной датой рождения
DELETE
FROM STUDENTS$
WHERE DATE_BIRTH IS NULL 

--2. ++ Измените дату рождения всех студентов, с неуказанной датой 
--    рождения на 01-01-1999
UPDATE STUDENTS$
 SET DATE_BIRTH = CAST('01-01-1999' AS DATE)
WHERE DATE_BIRTH IS NULL

--3. ++ Удалите из таблицы студента с номером зачётки 21
DELETE
FROM STUDENTS$
WHERE N_Z = 21

--4.  Уменьшите риск хобби, которым занимается наибольшее 
--    количество человек

-- тут только есть нюанс - у нас риск от 0 до 10 (ну или примерно)
-- т.е. есть ограничение. И если у какого-то хобби, допустим
-- риск <1 то будет нарушение целостности
-- и не поменяется ни у кого 

UPDATE HOBBIES$
  SET RISK = RISK - 1
  WHERE ID = (SELECT HOBBY_ID
                   FROM STUDENTS_HOBBIES$
                   GROUP BY HOBBY_ID
                   ORDER BY COUNT(*) DESC FETCH FIRST 1 ROWS ONLY --DISTINCT не работает, для чего он?
             ) AND RISK > 1

--5. ++ Добавьте всем студентам, которые занимаются хотя бы 
--     одним хобби 0.01 балл
UPDATE STUDENTS$
 SET SCORE = SCORE - 0.01
 WHERE N_Z IN ( SELECT DISTINCT N_Z
                FROM STUDENTS_HOBBIES$
                WHERE DATE_FINISH IS NOT NULL
 ) 

--6. ++ Удалите все завершенные хобби студентов
-- удалить s_h где data_finish is not null <-- только это

DELETE 
FROM STUDENTS_HOBBIES$
WHERE DATE_FINISH IS NOT NULL

--7. ++ Добавьте студенту с n_z 4 хобби с id 5. 
--     date_start - '15-11-2009, date_finish - null
INSERT INTO STUDENTS_HOBBIES$ (ID, N_Z, HOBBY_ID, DATE_START, DATE_FINISH)
VALUES (16, 4, 5, '15-11-2009', NULL)
 
 --8. ++ Напишите запрос, который удаляет самую раннюю из студентов_хобби
--      запись, в случае, если студент делал перерыв в хобби 
--      (т.е. занимался одним и тем же несколько раз)

DELETE
FROM STUDENTS_HOBBIES$
WHERE ID IN (
SELECT ID
FROM (
SELECT N_Z, MIN(ID) ID
FROM STUDENTS_HOBBIES$
WHERE N_Z IN (
SELECT DISTINCT T1.N_Z
FROM (
SELECT S_H.N_Z, S_H.HOBBY_ID, COUNT(S_H.HOBBY_ID) COUNT
FROM STUDENTS_HOBBIES$ S_H
INNER JOIN (
SELECT N_Z
FROM STUDENTS_HOBBIES$
GROUP BY N_Z
HAVING COUNT(N_Z) > 1
ORDER BY N_Z
) S ON S.N_Z = S_H.N_Z
GROUP BY S_H.N_Z, S_H.HOBBY_ID
ORDER BY S_H.N_Z
) T1

INNER JOIN (
SELECT S_H.N_Z, S_H.HOBBY_ID, COUNT(DISTINCT S_H.HOBBY_ID) COUNT
FROM STUDENTS_HOBBIES$ S_H
INNER JOIN (
SELECT N_Z
FROM STUDENTS_HOBBIES$
GROUP BY N_Z
HAVING COUNT(N_Z) > 1
ORDER BY N_Z
) S ON S.N_Z = S_H.N_Z
GROUP BY S_H.N_Z, S_H.HOBBY_ID
ORDER BY S_H.N_Z
) T2 ON T2.N_Z = T1.N_Z
WHERE T1.COUNT > T2.COUNT
) AND 
     DATE_FINISH IS NOT NULL
GROUP BY N_Z
ORDER BY N_z
) T
)

--9. ++ Поменяйте название хобби всем студентам, кто занимается футболом - 
--      на бальные танцы, а кто баскетболом - на вышивание крестиком.

--добавил хобби бальные танцы и вышивание крестиком
UPDATE STUDENTS_HOBBIES$
SET HOBBY_ID = CASE
WHEN  HOBBY_ID = '1' THEN '9'
ELSE '10'
END 
WHERE HOBBY_ID IN ('1', '3')

--поменял названия хобби
UPDATE HOBBIES$
SET NAME = CASE
WHEN  NAME = 'Баскетбол' THEN 'Вышивание крестиком'
ELSE 'Бальные танцы'
END WHERE NAME IN ('Футбол', 'Баскетбол')

--10. ++ Добавьте в таблицу хобби новое хобби с названием "Учёба"

-- id только не надо указывать - автоматом добавляется
-- (правда мб косяк и последовательность по началу возвращает число,
-- которое занято)

INSERT INTO HOBBIES$ (ID, NAME, RISK)
VALUES (11, 'Учёба', .10)

--11. ++ У всех студентов, средний балл которых меньше 3.2 поменяйте 
--     во всех хобби (если занимается чем-либо) и добавьте 
--     (если ничем не занимается), что студент занимается 
--     хобби из 10 задания

--изменить если есть хобби ++
UPDATE STUDENTS_HOBBIES$
SET HOBBY_ID = '11'
WHERE HOBBY_ID IN (
SELECT HOBBY_ID
FROM STUDENTS_HOBBIES$
WHERE N_Z IN (
SELECT N_Z
FROM STUDENTS$
WHERE SCORE < 3.2)
)

--изменить если нету хобби
 INSERT INTO STUDENTS_HOBBIES$ (N_Z, HOBBY_ID, DATE_START, DATE_FINISH)
SELECT S.N_Z, '11', SYSDATE, NULL
FROM STUDENTS$ S
WHERE S.N_Z IN (
SELECT *
FROM (
SELECT N_Z
FROM STUDENTS$
WHERE SCORE < 3.2
) G
WHERE N_Z NOT IN (
SELECT DISTINCT N_Z
FROM STUDENTS_HOBBIES$ 
WHERE N_Z IN (
SELECT N_Z
FROM STUDENTS$
WHERE SCORE < 3.2)
)
)

--как соеднить два условия?

INSERT INTO STUDENTS_HOBBIES$ (N_Z, HOBBY_ID, DATE_START, DATE_FINISH)
Select n_z, hobby_id, sysdate, null
-- т.е. в STUDENTS_HOBBIES$ будет добавлена каждая строчка из
-- того, что возвращает select. Осталось дописать запрос))

--12. +++ Переведите всех студентов не 4 курса на курс выше
UPDATE STUDENTS$
SET N_GROUP = N_GROUP + 1000 
WHERE SUBSTR(N_GROUP,1,1) IN (
SELECT SUBSTR(N_GROUP,1,1) CURSE
FROM STUDENTS$
WHERE SUBSTR(N_GROUP,1,1) < 4)

--13. ++ Удалите из таблицы студента с номером зачётки 2

-- угу, ток там ещё эти же задания сделать 
-- без каскадного удаления)

--не работает
DELETE
      FROM STUDENTS$ S, STUDENTS_HOBBIES$ S_H
      WHERE S_H.N_Z =S.N_Z AND S.N_Z = 2


--Только через скрипт?
DELETE
      FROM STUDENTS_HOBBIES$$
      WHERE N_Z = 2;

DELETE
      FROM STUDENTS$
      WHERE N_Z = 2;

--14. ++ Измените средний балл у всех студентов, которые занимаются 
--     хобби более 10 лет на 5.00
UPDATE STUDENTS$
SET SCORE = 5
WHERE N_Z IN (
SELECT N_Z
FROM
   (SELECT N_Z,
                     max(CASE
                             WHEN s_h.DATE_FINISH IS NULL THEN sysdate - s_h.DATE_START
                             ELSE s_h.DATE_FINISH - s_h.DATE_START
                         END) DAYS
      FROM STUDENTS_HOBBIES$ S_H
    GROUP BY N_Z) D_N
WHERE DAYS > 3650 )

--15. ++ Удалите информацию о хобби, если студент начал им заниматься 
--     раньше, чем родился
DELETE 
FROM STUDENTS_HOBBIES$
WHERE ID IN (
SELECT T2.ID
FROM (
SELECT N_Z, DATE_BIRTH AS D_B
FROM STUDENTS$ ) T1
INNER JOIN 
           ( SELECT T.ID, G.*
             FROM (
                   SELECT S_H.N_Z, MIN(S_H.DATE_START) AS D_S
                    FROM STUDENTS_HOBBIES$ S_H
                   GROUP BY S_H.N_Z  ) G
                     INNER JOIN (SELECT ID, N_Z FROM STUDENTS_HOBBIES$) T ON T.N_Z = G.N_Z
                  ) T2 ON T2.N_Z = T1.N_Z
WHERE T1.D_B > T2.D_S )


-- P.S. https://github.com/RyabovNick/databasecourse2019/tree/master/Tasks/2_Queries#разное


--5. Разное
--1. Вывести ФИО и ранк студентов в зависимости от их среднего балла. 
--    Если существует 2 и более студентов с одинаковым баллом, 
--    то они должны идти под одинаковым номером.


--1.1. Без пропусков номеров (не важно сколько студентов имеют 
--       одинаковый балл, следующий студент с отличающимся баллом 
--       будет иметь следующий ранк (6 студентов с одинаковы баллом 
--       и ранком - 6, следующий студент ранк 7))
SELECT NAME, SURNAME, SCORE, DENSE_RANK() OVER(ORDER BY SCORE DESC) RANK 
FROM STUDENTS$

--1.2. С пропуском номеров (если 3 студента 6 номер, то следующий 
--       должен быть иметь 9 ранк)
SELECT NAME, SURNAME, SCORE, RANK() OVER(ORDER BY SCORE DESC) RANK 
FROM STUDENTS$

SELECT NAME, SURNAME, SCORE, (Select ... score >= t.score) 
FROM STUDENTS$

SELECT NAME, SURNAME, SCORE, (Select
                               case 
                                when score <= t.score then rank+1 -- AND T.SCORE = SCORE  
								--ОПЕРАТОР = НЕ РАБОТАЕТ ПО ДРУГОМУ ОЧЕНЬ СЛОЖНО
                               end 
                              from( select 0 as rank, 0 AS SCORE  from DUAL) t) 
FROM STUDENTS$
ORDER BY SCORE DESC


--2. напишите запрос, который позволяет найти коэффициент отмены 
--     запросов незабаненными пользователями в заданный период 1 октября
--     2013 и 3 октября 2013. Запрос должен вернуть следующий 
--     результат для готовых данных (данные в таблице - не 
--     единственный вариант проверки написанного кода, будьте 
--     внимательнее. 
--Главное правильно решить задачу, а не вывести правильный результа):

SELECT REQUEST_AT, ( SELECT COUNT / COUNT(*) FROM USERS U INNER JOIN TRIPS T ON T.CLIENT_ID = U.USERS_ID WHERE REQUEST_AT BETWEEN '2013-10-01' AND '2013-10-03'
AND BANNED = 'No') as coefficient
FROM (


SELECT COUNT(*) AS COUNT, REQUEST_AT 
FROM USERS U
INNER JOIN TRIPS T ON T.CLIENT_ID = U.USERS_ID
WHERE REQUEST_AT BETWEEN '2013-10-01' AND '2013-10-03'
AND BANNED = 'No'
GROUP BY REQUEST_AT 
) F
ORDER BY REQUEST_AT 


--Что значит отменые запросы, пока вывел коэф незабаненых 
--      пользователей по указанный период


--Project1 что дальше делать?


