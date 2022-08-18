# Открытый банк вопросов по теории вероятностей и статистике

## Структура проекта

|  папка     |   содержимое  |
|:-----:|:----:|
|  base  | .Rmd файлы вопросов |
| snapshots | готовые файлы для импорта в онлайн-системы |
|  samplers  | скрипты на любом языке программирования для создания подборок |
| templates | tex-заготовки из которых генерируются pdf-версии вариантов |

## Общая логика

Мы храним базу вопросов в .Rmd и скрипты, которые собирают из этой базы варианты для любого повода. 
За исключением периодических полных образов базы, мы не храним вопросы, преобразованные для импорта в определённую систему. 
Вместо этого храним преобразующие скрипты.

Примеры .Rmd файла можно посмотреть в папке `base`.

## Структура Rmd файла

### Тестовый вопрос

```{yaml}
Question
========
Здесь идёт текст вопроса. (!) После слова Question не должно быть пробелов!
Можно использовать формулы $x^2 = 4$.
И большие тоже:
$$
f(x) =
\begin{cases}
0.5, \text{ если } x \in [0;2] \\
0, \text{ иначе }.
\end{cases}
$$

Найдите самое важное число $a$. 

Answerlist
----------
*  $\cos \pi$
*  $\sqrt{17}$
*  привет
*  нет верного ответа

Solution
========

Здесь идёт решение, которое можно показать студенту после окончания теста. 
Если нужны комментарии к каждому варианту ответа, то их можно оформить также 
с помощью строчки Answerlist, подчёркивания под ней и опций дальше. 

Meta-information
================
exname: bayesian approach with hedgehogs
extype: schoice
exsolution: 1000
exshuffle: 4
exextra[Type]: Calculation
exextra[Language]: Russian
exextra[Level]: Statistical Literacy
exsection: Inferential Statistics/Bayesian Statistics/Posterior
```

* exname: название вопроса, текст.
Должно быть уникальным! При нескольких совпадениях canvas косячит при импорте.
* extype: 
    * mchoice может быть много правильных ответов.
    * schoice может быть только один правильный ответ.
* exshuffle: сколько ответов из предложенных выбирать в вопрос. 
Не может быть больше числа опций в Answerlist. Мы ставим ровно столько. 
* exsolution: 1 кодирует верный ответ, 0 неверный. 
Количество 1 и 0 должно совпадать с количеством опций в Answerlist. 
* exsection: классификация по нашей [таксономии по теории вероятностей](https://github.com/bdemeshev/statistics_taxonomy/).


### Вопрос с числовым ответом

```{yaml}
Question
========
Здесь идёт текст вопроса. (!) После слова Question не должно быть пробелов!
Можно использовать формулы $x^2 = 4$.
И большие тоже:
$$
f(x) =
\begin{cases}
0.5, \text{ если } x \in [0;2] \\
0, \text{ иначе }.
\end{cases}
$$

Найдите самое важное число $a$. 

Solution
========

Здесь идёт решение, которое можно показать студенту после окончания теста. 

Meta-information
================
exname: bayesian approach with hedgehogs
extype: num
exsolution: 0
extol: 0.01
exextra[Type]: Calculation
exextra[Language]: Russian
exextra[Level]: Statistical Literacy
exsection: Inferential Statistics/Bayesian Statistics/Posterior
```

* extype: num вопрос с вводом ответа числом.
* exsolution: верный числовой ответ.
* extol: точность с которой принимаются ответы.
## Оформление таблиц

Таблицы в маркдаун легко оформить с помощью [генератора](https://www.tablesgenerator.com/markdown_tables).

Если коротко, то двоеточие определяет, в какую сторону идёт выравнивание. Формулы в таблице работают. 
```{md}
| Good | Bad  | Ugly |
|:-----|:----:|-----:|
|   1  |   2  | $X=3$|
```

При этом короткие таблицы в moodle выглядят приемлемыми, а большие — нет.
Лучше отказаться от больших таблиц. 

Если очень хочется оформить большую таблицу супер-дизайнерски со всей мощью html, то можно прочитать про таблицы в rexams [на stackoverflow](https://stackoverflow.com/questions/62222053/).

## Выбор тех-компилятора

```{r}
options(texi2dvi = Sys.which('xelatex'), exams_tex = 'tools') 
```

Опция `exams_tex` заставляет пакет `exams` использовать `tools`, а не `tinytex`. А далее мы скармливаем нужный компилятор.

## Подробнее про rexams:

* [Официальный сайт rexams](http://www.r-exams.org/)
* [Видео про rexams на youtube](https://www.youtube.com/playlist?list=PLsEZAAbioUw1IBnhtBi9eIo0uqMHmqDor)
* [Тэг на stackoverflow](https://stackoverflow.com/questions/tagged/r-exams)

Проект голландцев с открытой базов вопросов по статистике:

* [Официальный сайт sharestats](https://www.sharestats.nl/)
* [Таксономия голландцев](https://sharestats.github.io/Statistics_Taxonomy/Statistics_Taxonomy.html)

## Экспорт вопросов базы в онлайн-системы

Экспортировать всю базу в moodle .xml легко:

```{r}
library(tidyverse)
library(exams)

filenames = list.files('../base/', pattern = "*.Rmd", full.names = TRUE, recursive = TRUE)

res = exams2moodle(filenames,
    name = 'moodle-snapshot',
    dir = '../snapshots/',
    mchoice = list(shuffle = TRUE, enumerate = FALSE),
    schoice = list(shuffle = TRUE, enumerate = FALSE,
               eval = list(negative = 0, partial = TRUE, rule = 'none')))

```

Немного про опции:
* shuffle = TRUE рандомизация порядка ответов внутри вопроса
* enumerate = FALSE убирает буковки a/b/c/... у ответов, они облегчают обсуждение ответов, что на боевом тесте может быть нежелательным. 
* negative = 0 убирает штраф за неверный ответ. 
* partial = TRUE вообще говоря не применим к schoice, но функция без него ругается, надо разработчикам написать.
* rule = 'none' вообще говоря не применим к schoice, но функция без него ругается, надо разработчикам написать.


В канвас:
```{r}
res = exams2canvas(filenames)
```

Опции canvas такие же, как у moodle. 

* Нумерацию файлов разумно с лидирующими нулями, например,
`q_01.Rmd`, `q_02.Rmd`, ... При этом при загрузке в одну категорию в moodle они будут корректно отсортированы внутри категории. 

## Стилистика вопросов

* `\mathbb P`, `\mathbb E`, `\mathrm{Cov}`, `\mathrm{Var}`, `\mathrm{Corr}`.
* `\mathcal N`.
* Фраза всегда начинается со слова, и никогда не начинается с формулы.
* Внутри формул вместо ... используем `\ldots`.
* Не вводим обозначения, которые не используем.
* Большие формулы пишем с `$$`. По правилам современного теха нужно использовать 
`\[` и `\]`, но конвертер работает только с `$$`.
* Формулу со скобками пишем через `cases`:
```{tex}
$$
f(x) =
\begin{cases}
0.5, \text{ если } x \in [0;2] \\
0, \text{ иначе }.
\end{cases}
$$
```
* Не используем сокращения. Пишем полностью «случайная величина», «независимы и одинаково распределены»...
* Избавляемся от лишнего слова «пусть».

Вместо «Пусть случайная величина $X$ имеет» лучше написать «Случайная величина $X$ имеет».

* Почти во всех вопросах должна быть опция «нет верного ответа». Именно в таком каноническом написании.
* Moodle автоматически добавляет к вопросам типа schoice фразу «Выберите один ответ».
Поэтому все вопросы должны оканчиваться законченными фразами. То есть с точкой или знаком вопроса в конце. Неполные предложения надо исключить. Наиболее частые формулировки:
    * ... Найдите x. 
    * ... Чему равен х?


* В moodle корректно работает `\not\in` и очень плохо виден `\notin`.


## Другие форматы

* [конвертор gift2qti](https://github.com/csev/gift2qti), [и ещё](https://github.com/tsugitools/gift)
* [конвертор markdown2moodleXML](https://github.com/brunomnsilva/markdown2moodle)
* [amc2moodle](https://github.com/nennigb/amc2moodle)
* [latex moodle package](https://ctan.org/pkg/moodle)
* [moodle2latex](https://tex.stackexchange.com/questions/643627/)
* [jupyter quiz](https://github.com/jmshea/jupyterquiz)
* [r exams](https://www.r-exams.org/), [csv2rexams](https://r-forge.r-project.org/forum/forum.php?thread_id=33887&forum_id=4377&group_id=1337), [moodle2rexams](https://r-forge.r-project.org/forum/message.php?msg_id=47753&group_id=1337)
* [auto multiple choice](https://www.auto-multiple-choice.net/)
* [Pablo Angulo, pyexams](https://pypi.org/project/pyexams/)