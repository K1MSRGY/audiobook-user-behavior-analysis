SELECT*FROM audio_cards;
SELECT*FROM audiobooks;
SELECT*FROM listenings;
Сколько пользователей добавили книгу 'Coraline', сколько пользователей прослушало больше 10%
SELECT(
SELECT COUNT(DISTINCT ac.user_id)
FROM audio_cards ac
JOIN audiobooks a
ON ac.audiobook_uuid = a.uuid
WHERE a.title = 'Coraline'
) AS added_users,
(SELECT COUNT(DISTINCT l.user_id)
FROM listenings l
JOIN audiobooks a
ON l.audiobook_uuid = a.uuid
WHERE a.title = 'Coraline'
AND l.position_to > a.duration * 0.1
AND l.is_test = 0
) AS listened_more_than_10_percent;

Количество пользователей по каждой операционной системе и названию книги,
сумма прослушивания в часах, не учитывая тестовые прослушивания

SELECT
l.os_name,a.title,COUNT(DISTINCT l.user_id) AS users_count,
SUM(l.position_to - l.position_from) / 3600.0 AS listening_hours
FROM listenings l
JOIN audiobooks a
ON l.audiobook_uuid = a.uuid
WHERE l.is_test = 0
GROUP BY l.os_name, a.title
ORDER BY l.os_name, a.title;

Книга которую слушает больше всего людей

SELECT a.title,COUNT(DISTINCT l.user_id) AS users_count
FROM listenings l
JOIN audiobooks a
ON l.audiobook_uuid = a.uuid
WHERE l.is_test = 0
GROUP BY a.title
ORDER BY users_count DESC
LIMIT 1;

Книга которую чаще всего дослушивают до конца

-- Найти книгу, которую чаще всего дослушивают до конца

SELECT a.title,COUNT(DISTINCT l.user_id) AS users_count
FROM listenings l
JOIN audiobooks a
ON l.audiobook_uuid = a.uuid
WHERE l.is_test = 0
AND l.position_to = a.duration
GROUP BY a.title
ORDER BY users_count DESC
LIMIT 1;