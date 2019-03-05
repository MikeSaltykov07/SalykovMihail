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
              MAX(SCORE) as MAX_score,
       FROM STUDENTS
       GROUP BY N_GROUP
     )
WHERE N_GROUP AND
      MAX_score = STUDENTS.SCORE
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
-- во-первых в group by тут никакого смысла
-- во-вторых запрос выводит студента, который раньше всех начал заниматься хобби, а не самое продолжительное время
SELECT s.NAME,
       s.SURNAME,
       s_h.DATE_START
FROM STUDENTS s,
     STUDENTS_HOBBIES s_h
WHERE s.N_Z = s_h.N_Z
GROUP BY s.NAME, s.SURNAME, s_h.DATE_START
ORDER BY MIN(s_h.DATE_START) ASC FETCH FIRST 1 ROWS ONLY
--3. Вывести имя, фамилию, номер зачетки и дату рождения для студентов, средний балл которых выше среднего, 
--     а риск всех хобби, которыми он занимается в данный момент больше 0.9.
-- условие на средний балл надо не прибить гвоздями, а именно посчитать средний
-- надо посчитать сумму всех рисков, а не просто 0.9
SELECT s.N_Z,
       s.NAME,
       s.SURNAME,
       s.DATE_BIRTH,
       h.NAME
FROM STUDENTS s,
     STUDENTS_HOBBIES s_h,
     HOBBIES h
WHERE s.N_Z = s_h.N_Z AND
      s_h.HOBBY_ID = h.ID AND
      s.SCORE > 4 AND
      h.RISK > 0.9
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
       h.NAME,
       to_char(sysdate, 'YYYY') - to_char(DATE_BIRTH, 'YYYY') as years
FROM STUDENTS s,
     STUDENTS_HOBBIES s_h,
     HOBBIES h
WHERE s.N_Z = s_h.N_Z AND
      s_h.HOBBY_ID = h.ID AND
      --years = :YEARS; почему нет? Потому что select срабатывает после where
      -- нет условия про одно действующее хобби
      to_char(sysdate, 'YYYY') - to_char(DATE_BIRTH, 'YYYY') >= :YEARS;

--6. Найти средний балл в каждой группе, учитывая только баллы студентов, которые имеют хотя бы одно действующее хобби.
-- нет смысла тащить в запросе таблицу хобби - это всё доп. вычисления, которые замедляют запрос (в 5 тоже кстати).
-- нет условия про "действующее хобби"
SELECT s.N_GROUP, --не работает
       AVG(s.SCORE) as AVG_score
FROM STUDENTS s,
     STUDENTS_HOBBIES s_h,
     HOBBIES h
WHERE s.N_Z = s_h.N_Z AND
      s_h.HOBBY_ID = h.ID AND
      s_h.HOBBY_ID IS NOT NULL
GROUP BY s.N_GROUP 
--7. Найти название, риск, длительность в месяцах самого продолжительного хобби из действующих, 
--    указав номер зачетки студента и номер его группы.
-- нет условия про "из действующих"
-- max & group by тут нет необходимости использовать
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
      s_h.HOBBY_ID IS NOT NULL
GROUP BY s.N_Z,
         s.N_GROUP,
         h.NAME,
         h.RISK
ORDER BY MAX_month DESC FETCH FIRST 1 ROWS ONLY
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
      s.N_GROUP like '2%';
--10. Найти номера курсов, на которых студенты имеют в среднем более одного действующего хобби.

















