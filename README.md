# Банк вопросов по теории вероятностей и статистике

## Структура проекта

|  папка     |   содержимое  |
|:-----:|:----:|
|  base  | .Rmd файлы вопросов, отсортированы по экзамену, для которого составлены |
| snapshots | готовые файлы для импорта в онлайн-системы |
|  samplers  | скрипты на любом языке программирования для создания подборок |

## Общая логика

Мы храним базу вопросов в .Rmd и скрипты, которые собирают из этой базы варианты для любого повода. 
За исключением периодических полных образов базы, мы не храним вопросы, преобразованные для импорта в определённую систему. 
Вместо этого храним преобразующие скрипты.

Структуру типичного .Rmd файла можно подглядеть в любом старом .Rmd файле. 

Таблицы в маркдаун легко оформить с помощью [генератора](https://www.tablesgenerator.com/markdown_tables).

Если коротко, то двоеточие определяет, в какую сторону идёт выравнивание. Формулы в таблице работают. 
```{md}
| Good | Bad  | Ugly |
|:-----|:----:|-----:|
|   1  |   2  | $X=3$|
```

Тема про таблицы в rexams [на stackoverflow](https://stackoverflow.com/questions/62222053/).


Подробнее про rexams:

* [Официальный сайт rexams](http://www.r-exams.org/)
* [Видео про rexams на youtube](https://www.youtube.com/playlist?list=PLsEZAAbioUw1IBnhtBi9eIo0uqMHmqDor)
* [Тэг на stackoverflow](https://stackoverflow.com/questions/tagged/r-exams)

Проект голландцев с открытой базов вопросов по статистике:

* [Официальный сайт sharestats](https://www.sharestats.nl/)
* [Таксономия](https://sharestats.github.io/Statistics_Taxonomy/Statistics_Taxonomy.html)

## код в R 

Экспортировать всю базу в moodle .xml легко:

```{r}
library(tidyverse)
library(exams)

files_df = tibble(filename = list.files('../base/', pattern = "*.Rmd", full.names = TRUE, recursive = TRUE))
res = exams2moodle(files_df$filename)
```

В канвас:
```{r}
res = exams2canvas(files_df$filename)
```

## Стилистика

* `\mathbb P`, `\mathbb E`, `\mathrm{Cov}`, `\mathrm{Var}`, `\mathrm{Corr}`;
* `\mathcal N`;
* Фраза всегда начинается со слова, и никогда не начинается с формулы;
* Внутри формул вместо ... используем `\ldots`;
* Не вводим обозначения, которые не используем;
* Большие формулы пишем с `$$`. По правилам современного теха нужно использовать 
`\[` и `\]`, но конвертер работает только с `$$`;
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
* Не используем сокращения.
