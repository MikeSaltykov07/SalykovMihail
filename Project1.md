# Музыкальный справочник

Спроектировать базы данных для
онлайнового музыкального справочника.
Система должна предусматривать хранение информации о музыкальных группах. Для каждого
коллектива задаются краткие описания и музыкальные жанры, в которых он работает. Помимо этого
должна храниться информация об участниках, в том числе роль в коллективе (гитарист, вокалист,…).
В случае если состав группы менялся, это тоже должно быть зафиксировано.
Должен храниться список альбомов с детальной информацией по каждому из них (название, год
выпуска, жанры, лейбл,…), а также списком композиций (название, авторы, длительность,…).
Альбомы могут быть студийными, концертными, компиляциями. Если у группы было несколько
составов, должно быть понятно, какой состав записал тот или иной альбом
Одна и та же композиция может быть задействована на нескольких альбомах.
Если участник группы занимался сольным творчеством, такую информацию хранить не
требуется.

**Ограничения целостности:**

1. Год выпуска альбома не может быть больше текущего (подсказка: используйте функции Date
   и Year).
2. Длительность композиции не может быть больше 60 минут.