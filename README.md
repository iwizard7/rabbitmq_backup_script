# Скрипт резервного копирования для RabbitMQ ⚙️
_Social buttons_

[![iwizard7 - iwizard7](https://img.shields.io/static/v1?label=iwizard7&message=iwizard7&color=blue&logo=github)](https://github.com/iwizard7/iwizard7 "Go to GitHub repo")
[![stars - iwizard7](https://img.shields.io/github/stars/iwizard7/iwizard7?style=social)](https://github.com/iwizard7/iwizard7)
[![forks - iwizard7](https://img.shields.io/github/forks/iwizard7/iwizard7?style=social)](https://github.com/iwizard7/iwizard7)


_Repo metadata_


[![GitHub tag](https://img.shields.io/github/tag/iwizard7/iwizard7?include_prereleases=&sort=semver&color=blue)](https://github.com/iwizard7/iwizard7/releases/)
[![License](https://img.shields.io/badge/License-MIT-blue)](#license)
[![issues - iwizard7](https://img.shields.io/github/issues/iwizard7/iwizard7)](https://github.com/iwizard7/iwizard7/issues)

Этот скрипт Bash предназначен для создания резервных копий данных RabbitMQ и сохранения их в Git-репозиторий. Вот как он работает:

## Параметры

В начале скрипта определены несколько параметров, которые можно настроить в соответствии с вашими потребностями:

- `GIT_REPO_PATH`: Путь к локальному Git-репозиторию, где будут храниться резервные копии.
- `GIT_REPO_FULL_PATH`: Полный путь к папке в Git-репозитории, где будут сохраняться резервные копии для конкретного кластера RabbitMQ.
- `RABBITMQ_CFG_PATH`: Путь к конфигурационному файлу `rabbitmq.config` на вашей системе.
- `TMP_PATH`: Временная папка, где будут создаваться временные файлы и архивы.
- `MNESIA_COPY`: Флаг, указывающий, нужно ли копировать папку `mnesia`. Если установлено значение `true`, скрипт остановит сервис RabbitMQ, создаст архив `mnesia` и затем снова запустит сервис.
- `MNESIA_DIR`: Путь к папке `mnesia` в RabbitMQ.

## Копирование папки `mnesia`

Если переменная `MNESIA_COPY` установлена в значение `true`, скрипт выполнит следующие действия:

1. Остановит сервис RabbitMQ с помощью команды `rabbitmqctl stop_app`.
2. Создаст архив `zip` из папки `mnesia` с использованием команды `zip`.
3. Запустит сервис RabbitMQ снова с помощью команды `rabbitmqctl start_app`.

Если переменная `MNESIA_COPY` установлена в значение `false`, этот шаг будет пропущен.

## Проверка наличия папок

Следующий блок кода проверяет наличие папок `/opt/git` и `/opt/tmp` и создает их, если они отсутствуют.

## Выгрузка бэкапа с помощью `rabbitmqadmin`

Скрипт использует утилиту `rabbitmqadmin` для выгрузки схемы данных RabbitMQ в формате JSON. Выгрузка происходит с использованием команды `rabbitmqadmin export`, и результат сохраняется в файл `schema_$(hostname -s).json` во временной папке.

## Копирование конфигурационного файла

Скрипт копирует файл `rabbitmq.config` из указанного пути `RABBITMQ_CFG_PATH` во временную папку. Имя файла будет иметь формат `rabbitmq_$(hostname -s).config`, где `$(hostname -s)` - это имя текущей ноды.

## Создание архива

Скрипт создает архив `zip` с помощью команды `zip -r -P ****** $(hostname -s).zip *` во временной папке. Архив будет защищен паролем `******`, и его имя будет иметь формат `$(hostname -s).zip`, где `$(hostname -s)` - это имя текущей ноды.

## Перемещение архива в Git-репозиторий

Скрипт перемещает созданный архив в папку `GIT_REPO_FULL_PATH` в локальном Git-репозитории.

## Удаление временных файлов

Скрипт удаляет временные файлы `rabbitmq_$(hostname -s).config` и `schema_$(hostname -s).json` из временной папки.

## Добавление и коммит в Git

Скрипт выполняет команды `git add --all` и `git commit -m "Добавлен бэкап cluster_name нода nodename"` для добавления и коммита изменений в Git-репозиторий.

## Отправка в удаленный Git-репозиторий

Скрипт отправляет изменения в удаленный Git-репозиторий с помощью команды `git push origin master`.

---
