# the_movie_db

Тренировка, создания приложения [The Movie DB](https://www.themoviedb.org/)

# Этапы

## Начало:
- Верстка интерфейса и мелкие фичи
- Создание кастомного виджета с помощью CustomPainter 

## Данные:
### Созданы классы для 
- Список персонала обслуживающий фильм
- Получение ютуб видео
- Детальная информация о фильме 
- Краткая информация о фильме
- Получения списка популярных фильмов
### Запросы
#### Get 
- Запросы на авторизацию 
- Получения списка фильмов 
- Полчение детальной инфы о фильме 
- Поиск фильмов
- ...
#### Post 
- Получение сессии 
- Добавление фильма в избранное и удаление от туда 
## Обработка Json 
- Все запросы с Json с генерацие кода в BuildRunner and Json Annotation

## State manage:
- Используется Provider созланный на основе инхеритов для управления состоянием
## Обработка ошибок:
- На стороне клиента Отсутствие сети
- Ответы с сервера при неверных данных логина/пароля
- Ошибки сервера когда он не доступен 

## Доделать
- [x] Изменение цвета фона взятого из постера готово
- [x] Выход из профиля
- [ ] Нет отображения создателей фильма 
- [ ] Создание экрана с новостями  
- [ ] Создание экрана с сериалами  
<!-- - [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook) -->

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# This is an <h1> tag
## This is an <h2> tag
###### This is an <h6> tag

*This text will be italic*
_This will also be italic_
**This text will be bold**
__This will also be bold__
*You **can** combine them*

1. Item 1
2. Item 2
3. Item 3
 * Item 3a
 * Item 3b

 http://github.com - automatic!
[GitHub](http://github.com)

As Grace Hopper said:
> I’ve always been more interested
> in the future than in the past.

\*literal asterisks\*

#1
github-flavored-markdown#1
defunkt/github-flavored-markdown#1

GitHub supports emoji!
:+1: :sparkles: :camel: :tada:
:rocket: :metal: :octocat:

```javascript
function test() {
 console.log("look ma’, no spaces");
}
```

- [x] this is a complete item
- [ ] this is an incomplete item
- [x] @mentions, #refs, [links](),
**formatting**, and <del>tags</del>
supported
- [x] list syntax required (any
unordered or o

First Header | Second Header
------------ | -------------
Content cell 1 | Content cell 2
Content column 1 | Content column 2
