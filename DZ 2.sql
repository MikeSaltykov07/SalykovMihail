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
       --так нормально. Максимальный размер идентификатора - 30 символов, киррилица 1 за 2
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
SELECT AVG(SCORE)
FROM STUDENTS
WHERE N_GROUP>=2000 AND N_GROUP<3000; --хз как масштабировать на все курсы
--6. Для студентов заданного курса вывести один номер групп с максимальным средним баллом
SELECT -- N_GROUP,
       MAX(AVG(SCORE)) AS MAX
FROM STUDENTS
where N_GROUP between 2000 and 3000
GROUP BY N_GROUP;
--7. Для каждой группы подсчитать средний балл, вывести на экран только те номера групп и их средний балл, 
--      в которых он менее или равен 3.5. Отсортировать по от меньшего среднего балла к большему.


























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
SELECT MIN(s_h.DATE_START)
FROM STUDENTS s,
     STUDENTS_HOBBIES s_h
WHERE s.N_Z = s_h.N_Z;

