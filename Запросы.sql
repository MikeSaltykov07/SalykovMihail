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
    -- Всем людям добавить приставку ('the_' + первую букву группы + '_') к никнэйму в указанной группе
    -- Изменить никнэйм самого вокалиста, указанной группы
    
-- 13. Сформулируйте и напишите 3 запроса на удаление данных, которые будут полезны в вашем проекте
	-- Удалить составы групп длившиесЯ не больше года если за это время не было альбомов
    -- Удалить людей бывших в одном составе
    -- Удалить самых непопулярных авторов каждой группе




