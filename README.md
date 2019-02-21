# lung
Проект по немелоклеточному рл

##Версия ведется в version templates/footer.tpl файле
Формат: `yy.mm.dd.idx`
`yy`  - год, до 2х знаков
`mm`  - месяц, до 2х знаков
`dd`  - день, до 2х знаков
`idx` - порядковый номер ревизии в текущем дне, начиная с 1

История изменений (расти вверх)
ver. 19.02.21.01
	+ добавил режим на чтение
ver. 18.10.04.01
	~ Исправил ошибку в сообщении эл. почты при регистрации.
ver. 18.09.15.01
	+ Добавил хирургическое лечение
ver. 18.09.07.01
	+ на форме хт если нейротоксичность нет, то селект с уровнем не нужно выбирать (кожная токсичнось - аналогично)
	~ подправил обратную связь  
ver. 18.07.16.01
	+ при регистрации по коду доступа присваивается роль
ver. 18.07.02.02
	+ при обновлении пациента, колонка user не меняется
ver. 18.07.02.01
	+ добавил - если пользователь имеет роль 'investigator', в списке пациентов отображаются только те пациенты,
	  которых он добавлял (по колонке 'user')
ver. 18.06.24.01
	+ добавил обработку форму пациента в JS
ver. 18.06.15.01
	+ сохранение и обновление therapy
ver. 18.06.10.02
	+ скрипт по созданию БД
ver. 18.06.10.01
	+ Первый коммит

