-- 1. Заполнить таблицы данными, необходимыми для наглядного выполнения запросов
-- "/бд.txt"
-- 2. Написать запрос на каждую таблицу, который добавляет в неё данные (исключая атрибут, который заполняется при помощи автоинкремента)
INSERT INTO Album(`Id_Album`,`Id_collectives`,`Id_group`,`Name`,`Year`) VALUES (1, 1, 8, 'Please Please Me', 1963);
INSERT INTO Album_Compositions(`Id_album`, `Id_compositions`) VALUES (1, 'I Saw Her Standing There', 2*60+54);
INSERT INTO Album_Genre(`Id_album`, `Id_genres`) VALUES (1,1);
INSERT INTO Album_Label(`Id_album`, `Id_label`) VALUES (1,1);
INSERT INTO Author (`Id_Author`, `Id_compositions`) VALUES (1,1);
INSERT INTO Collectives (`Id_Collectives`, `Name`, `Info`) VALUES (1,'The Beatles','Британская рок-группа из Ливерпуля');
INSERT INTO Collectives_Genres (`Id_collectives`, `Id_genres`) VALUES (1,1);
INSERT INTO Compositions (`Id`, `Name`, `Duration`) VALUES (1, 'I Saw Her Standing There', 2*60+54);
INSERT INTO Compositions_Genres (`Compositions_Id`, `Genres_Id`) VALUES (1,1);
INSERT INTO Genres (`Id`, `Name`) VALUES (5, 'Рок-Н-Ролл');
INSERT INTO `Group` (`Id_Group`, `Id_collectives`, `Date_Start`, `Date_Finish`) VALUES (8, 1,'1962-08-16','1969-09-26');
INSERT INTO Group_People (`Id_group`, `Id_people`) VALUES (1,7);
INSERT INTO Label (`Id`, `Name`) VALUES (1, 'Parlophone');
INSERT INTO People (`Id_People`, `Nickname`, `Name`, `Surname`) VALUES (2, 'Пол Макка́ртни', 'Джеймс Пол', 'Макка́ртни');
INSERT INTO People_Roles (`Id_People`, `Id_Roles`) VALUES (2,1);
INSERT INTO Roles (`Id`, `Name`) VALUES (1, 'Вокал');

-- 3. Написать запрос на каждую таблицу, который возвращает запись с заданными ID
select * from Album where Id_Album=1;
select * from Album_Compositions where Id_compositions=4;
select * from Album_Genre where Id_album=1 and Id_genres=4;
select * from Album_Label where Id_album=5;
select * from Author where Id_Author=1;
select * from Collectives where Id_Collectives=2;
select * from Collectives_Genres where Id_Collectives=2;
select * from Compositions where id=11;
select * from Genres where id=6;
select * from `Group` where Id_Group=8;
select * from Group_People where Id_Group=8;
select * from Label where id=4;
select * from People where Id_People=12;
select * from People_Roles where Id_People=1;
select * from Roles where id=1;

-- 4. Написать запрос на каждую таблицу, который изменяет данные для заданного ID
UPDATE Album SET Year = 1963 where Id_Album=1;
UPDATE Album_Compositions SET Id_album = 1 where Id_compositions=1;
UPDATE Album_Genre SET Id_album = 1 where Id_genres=6;
UPDATE Album_Genre SET Id_label = 4 where Id_album=6;
UPDATE Author SET Id_Author = 4 where Id_compositions=6 and Id_Author=1;
UPDATE Collectives SET Info = 'Британская рок-группа из Ливерпуля' where id_collectives=1
UPDATE Collectives_Genres SET Id_collectives = 5 where Id_genres=6 and Id_collectives=1;
UPDATE Compositions SET id = 5 where Duration=626;
UPDATE `Group` SET Id_collectives = 2 where Id_Group=5;
UPDATE Group_People SET Id_people = 2 where Id_group= 5 and Id_people=1;
UPDATE Label SET `Name` = 'Parlophone' where Id= 1;
UPDATE People SET `Name` = 'Джон Уи́нстон О́но' where Id_People = 1;
UPDATE People_Roles SET Id_Roles = 5 where Id_People = 1 and Id_Roles = 3;
UPDATE Roles SET `Name` = 'Вокал' where Id = 1;

-- 5. Написать запрос на каждую таблицу, который удаляет запись в таблице с заданным ID
delete from Album where Id_Album=2;
delete from Album_Compositions where Id_compositions=4;
delete from Album_Genre where Id_album=2 and Id_genres=3;
delete from Album_Label where Id_album=6;
delete from Author where Id_Author=4;
delete from Collectives where Id_Collectives=1;
delete from Collectives_Genres where Id_Collectives=1;
delete from Compositions where id=10;
delete from Genres where id=4;
delete from `Group` where Id_Group=9;
delete from Group_People where Id_Group=9;
delete from Label where id=5;
delete from People where Id_People=14;
delete from People_Roles where Id_People=14;
delete from Roles where id=5;

-- 6. Выведите группу/ы, состав которой менялся чаще всего
-- можно без вложенности, используй having
select Id_collectives
 from (
      select Id_collectives, count(*) as `count`
       from `Group`
      group by   Id_collectives
 ) t
where t.`count` = (
                   select count(*)
                    from `Group`
                   group by  Id_collectives
                   limit 1
);

-- 7. У каждой группы выведите альбом, который относится к наибольшему числу жанров
-- интересный подход, но я бы так не делал
-- напиши ещё раз запрос, но также, как например
-- разбирали на паре 8 (вроде) задание на удаление.
-- т.е. 1 select - альбом и кол-во жанров,
-- а 2-ой выводит альбом и макс. кол-во жанров из всех альбомов
-- этой группы
-- и сравни cost выполнения запроса, что лучше)
select a.Id_collectives, (
                          select t.Id_album
                           from (
                                select  a.Id_album, count(*) as `count`
								 from Album_Genre a
								group by a.Id_album
						    ) u
                          inner join Album t on t.Id_Album = u.Id_Album
						  where t.Id_collectives = a.Id_collectives
						  group by u.Id_album
                          limit 1
   ) as `album_max_genre`
from Album a
group by a.Id_collectives

-- 8. Выведите людей, которые состояли более чем в 1 группе
-- ++
select p.*
from People p
inner join (
            select t.Id_people, count(*) as `count`
             from (
                  select Id_collectives, Id_people
                   from `Group` g
				  inner join `Group_People` t on t.`Id_group`=g.`Id_group`
				  group by Id_collectives, Id_people
			 ) t
			group by t.Id_people
            having `count` > 1
) c on c.Id_people = p.Id_people

-- 9. Выведите 3 самых длинных композиций в каждом жанре
-- для чего нужны @ ?)
select Genres_Id, Compositions_Id
from (
      select 
			@row_number:=CASE
	                        when @genre_no = t.Genres_Id then @row_number + 1
						    else 1
                         end as row_nu,
               @genre_no:= t.Genres_Id as Genres_Id_nu,
                  t.Genres_Id, t.Compositions_Id, t.Duration
	  from (
           select c_g.Genres_Id, c_g.Compositions_Id, c.Duration
             from Compositions c 
           inner join Compositions_Genres c_g on c_g.`Compositions_Id`= c.`id`
		   order by c_g.Genres_Id, c.Duration desc
       ) t join (SELECT @row_num := 0) a
) tt
where row_nu between 1 and 3

-- 10. Выведите группу, которая в заданном году дропнула больше всего альбомов
select c.*
  from Collectives c
  inner join (
              select Id_collectives, `Year`, count(*)
                from Album
              where `Year`= 1964
              group by Id_collectives, `Year`
              order by count(*) desc
              limit 1
  ) t on t.Id_collectives = c.Id_collectives


-- 11. Сформулируйте и напишите 5 запросов на получение данных, которые будут полезны в вашем проекте
-- критейрий полезности - мне интересны эти значения.  
-- ------------------------------------------------------------------------------------- --
    -- Сколько композиций написали члены группы
    select Id_collectives, count(*)
     from (
	       select distinct tt.Id_collectives, tt.Id_compositions
	        from (
	               select  t.Id_collectives, a.Id_compositions, a.Id_Author
					from (
						select  a.Id_collectives, a_c.Id_compositions
						  from Album a
						inner join `Album_Compositions` a_c on a_c.Id_Album = a.Id_Album
				   ) t
				  inner join `Author` a on a.Id_compositions= t.Id_compositions
            ) tt
            inner join (
                         select Id_collectives, Id_people
                           from `Group` g
                          inner join `Group_People` t on t.`Id_group`=g.`Id_group`
	                      group by Id_collectives, Id_people
            ) g on g.Id_people = tt.Id_Author
    ) ttt
	group by Id_collectives
-- -------------------------------------------------------------------------------------- --
	-- Люди которые были с создания до конца/по настоящее время
    select ttt.Id_collectives, p.Nickname
    from (
            select tt.Id_collectives, tt.Id_people
              from (
                    select  Id_collectives, Id_people, count(*) as `count`
                     from (
                            select g_p.*, g.Id_collectives
                             from Group_People g_p
                            inner join `Group` g on g.`Id_Group` = g_p.`Id_Group`
                    ) t
                    group by Id_collectives, Id_people
	) tt 
    join (
          select Id_collectives, count(*) as `count`
		   from `Group`
		  group by Id_collectives
     ) c 
     where tt.Id_collectives = c.Id_collectives and tt.`count` = c.`count`
    ) ttt
    inner join People p on p.Id_people = ttt.Id_people
-- -------------------------------------------------------------------------------------- --
	-- Основной(Самый частый) лейбл группы
    select tt.Id_collectives, tt.Id_label
    from (
	      select a.Id_collectives, a_l.Id_label, count(*) as `count`
           from Album_Label a_l
           inner join Album a on a.Id_album = a_l.Id_album 
		  group by a.Id_collectives, a_l.Id_label
    ) tt
    join (
           select Id_collectives, max(`count`) as `max`
            from  (
                    select a.Id_collectives, a_l.Id_label, count(*) as `count`
                     from Album_Label a_l
                    inner join Album a on a.Id_album = a_l.Id_album 
                    group by a.Id_collectives, a_l.Id_label
            ) t
			group by Id_collectives
    ) m
    where tt.Id_collectives = m.Id_collectives and tt.`count` = m.`max`
-- ------------------------------------------------------------------------------------- --
    -- 2 самых частых автора группы
    select Id_collectives, Id_Author
      from (
            select @row_num:=CASE
	                            when @coll = tt.Id_collectives then @row_num + 1
	    					    else 1
                             end as row_nu,
                   @coll:= tt.Id_collectives as Coll,
                          tt.Id_collectives, tt.Id_Author
             from (
				   select  t.Id_collectives, a.Id_Author, count(*) as `count`
                    from (
						  select  a.Id_collectives, a_c.Id_compositions
                            from Album a
                          inner join `Album_Compositions` a_c on a_c.Id_Album = a.Id_Album
                    ) t
                    inner join `Author` a on a.Id_compositions= t.Id_compositions
                    group by t.Id_collectives, a.Id_Author
                    order by t.Id_collectives, `count` desc
             ) tt join (SELECT @row_num := 0) a
    ) ttt
    where row_nu between 1 and 2
-- --------------------------------------------------------------------------------------- --
    -- Человек с большим колличеством роллей в каждоый группе
    select t1.Id_collectives, p.Nickname
     from (
            select  t.Id_collectives, p_r.Id_People, count(p_r.Id_Roles) as `count`
             from (
                    select g_p.Id_people, g.Id_collectives
				      from Group_People g_p
					inner join `Group` g on g.`Id_Group` = g_p.`Id_Group`
                    group by Id_collectives, Id_people
            ) t
            inner join People_Roles p_r on p_r.Id_People = t.Id_People
            group by t.Id_collectives, p_r.Id_People
    ) t1
    join (
            select Id_collectives, max(`count`) as `max`
             from (
                    select  t.Id_collectives, p_r.Id_People, count(p_r.Id_Roles) as `count`
                      from (
                            select g_p.Id_people, g.Id_collectives
                              from Group_People g_p
                            inner join `Group` g on g.`Id_Group` = g_p.`Id_Group`
                            group by Id_collectives, Id_people
					) t
                    inner join People_Roles p_r on p_r.Id_People = t.Id_People
                    group by t.Id_collectives, p_r.Id_People
            )tt
            group by Id_collectives
    ) t2
    inner join People p on p.Id_People = t1.Id_People
    where t1.Id_collectives = t2.Id_collectives and t1.`count`=t2.`max`
    
-- 12. Сформулируйте и напишите 3 запроса на изменение данных, которые будут полезны в вашем проекте
	-- Завершить существование состава, указанной группы
        update `Group`
          set Date_Finish = sysdate()
          where Id_collectives = 2 -- выбранный коллекив
				and Date_Finish is null
			--выпполнил но выдал значок предупреждения Incorrect date value: '2019-04-26 23:18:40' for column 'Date_Finish'
-- ------------------------------------------------------------------------------------------------------------- --
    -- Всем людям добавить приставку ('the_' + первую букву группы + '_') к никнэйму в указанной группе
      update People as p
	        inner join Group_People g_p on g_p.Id_people = p.Id_People
            inner join `Group` g on g.`Id_Group` = g_p.`Id_Group`
            inner join Collectives c on c.Id_collectives = g.Id_collectives
      set p.Nickname =  concat_ws('_', 'The', substr(c.`name`,4,2), p.`Nickname`,'')
            where g.Id_collectives = 1
      
	select @kk := instr('The Beatles', 'The '),
			@k := case 
                    when @kk > 0 then @kk + 3
                    else 0
		         end as p
from (SELECT @k := 0) -- Error Code: 1248. Every derived table must have its own alias
-- ------------------------------------------------------------------------------------------------------------- --
    -- Изменить никнэйм самого частого вокалиста, указанной группы
    update People as p set p.`Nickname`= p.`Nickname`
           where p.`Id_People` = ( -- с in не работает error 1175
								  select id_people
                                   from (
                                         select Id_collectives, max(roll) as `max`
                                            from (
												  select g_p.Id_people, g.Id_collectives, count(Id_Roles) as roll
                                                   from Group_People g_p
                                                  inner join `Group` g on g.`Id_Group` = g_p.`Id_Group`
                                                  inner join People_Roles p_r on p_r.Id_People = g_p.Id_People
                                                  where Id_Collectives = 1 and Id_Roles = 1
                                                  group by Id_collectives, Id_people
                                            ) t
                                            group by Id_collectives
                                    ) tt
                                   inner join (
                                              select g_p.Id_people, g.Id_collectives, count(Id_Roles) as roll
												from Group_People g_p
                                              inner join `Group` g on g.`Id_Group` = g_p.`Id_Group`
                                              inner join People_Roles p_r on p_r.Id_People = g_p.Id_People
                                              where Id_Collectives = 1 and Id_Roles = 1
                                              group by Id_collectives, Id_people
                                   ) t2 on t2.roll = tt.`max`
                                   limit 1
		   )
    
-- 13. Сформулируйте и напишите 3 запроса на удаление данных, которые будут полезны в вашем проекте
	-- Удалить составы групп длившиесЯ не больше года, если за это время не было альбомов
    create view Group_D_A_bool as
    select Id_group
     from (
           select distinct g.Id_Group, g.Id_collectives, g.Date_Finish - Date_Start < 365/2 as `Dbool`, (
                select 
                      case
                          when count(*) > 0 then 0 
                          else 1 
	    	          end 
	    	     from(select distinct * from Album a) t 
	    	     where t.Id_group = g.Id_Group
                 ) as `Abool`
            from `Group` g
            inner join Album a on a.Id_collectives = g.Id_collectives
    ) t
    where Dbool =1 and Abool = 1

    -- DELETE MULTI не получилось сделать
    delete  g_p
         from  `Group_People` as g_p
         join Group_D_A_bool gda on gda.Id_group = g_p.Id_Group

    delete  g
		  from  `Group` as g
          join Group_D_A_bool gda on gda.Id_group = g.Id_Group
-- ------------------------------------------------------------------------------------------------------------- --
    -- Удалить людей не входящих в группы или в авторы
    create view P_extra as
        select Id_People
         from People p
        inner join (
                    select Id_People as Gb_people
                    from (
						select p.Id_People, (
                                            select t.`count` > 0 
                                            from (select Id_people, count(*) as `count` from Group_People group by Id_people) t 
                                            where t.Id_people = p.Id_People
                        ) as Gbool
                        from People p
                    ) t
                    where Gbool is null
    ) gb on gb.Gb_people = p.Id_People
    inner join (
                select Id_People as Ab_people
                 from (
					   select p.Id_People, (
                                           select t.`count` > 0
										   from (select Id_Author, count(*) as `count` from Author group by Id_Author) t 
										   where t.Id_Author = p.Id_People
                                            ) as Abool
                        from People p
				) t
                where Abool is null
    ) ab on ab.Ab_people = p.Id_People
    
	delete p_r
          from People_Roles p_r
          inner join P_extra p_e on p_e.Id_People = p_r.Id_People
    
    delete p
          from People p
          inner join P_extra p_e on p_e.Id_People = p.Id_People
-- ------------------------------------------------------------------------------------------------------------- --
    -- Удалить самых непопулярных авторов каждой группе
    create view Autor_min as
        select t.Id_collectives, t.Id_Author
		 from (
			   select al.`Id_collectives`, a.Id_Author, count(*) as `count`
			    from Author a
			   inner join Compositions c on c.id = a.Id_compositions
			   inner join Album_Compositions a_c on a_c.`Id_compositions` = c.id
			   inner join Album al on al.`Id_Album` = a_c.`Id_album`
			   group by al.`Id_collectives`, a.Id_Author
		 ) t
       join (
             select Id_collectives, min(`count`) as `min`
             from (
                   select al.`Id_collectives`, a.Id_Author, count(*) as `count`
                     from Author a
                   inner join Compositions c on c.id = a.Id_compositions
                   inner join Album_Compositions a_c on a_c.`Id_compositions` = c.id
                   inner join Album al on al.`Id_Album` = a_c.`Id_album`
                   group by al.`Id_collectives`, a.Id_Author
		     ) tt
             group by Id_collectives
        ) m
        where m.Id_collectives = t.Id_collectives and t.`count` = m.`min`

         delete a
               from Author a
               inner join Autor_min a_m on a_m.Id_Author = a.Id_Author
               
        delete p
              from People p
              inner join P_extra p_e on p_e.Id_People = p.Id_People

