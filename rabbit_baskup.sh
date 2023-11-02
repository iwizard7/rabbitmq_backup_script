#!/bin/bash
   
# Параметры
GIT_REPO_PATH="/opt/git/backup_cfg/"
GIT_REPO_FULL_PATH="/opt/git/backup_cfg/RabbitMQ/cluster_name"
RABBITMQ_CFG_PATH="/var/lib/rabbitmq/config/generated/rabbitmq.config"
TMP_PATH="/opt/tmp/"
MNESIA_COPY=false
MNESIA_DIR="/var/lib/rabbitmq/mnesia"
 
# Копирование директории mnesia
if [ "$MNESIA_COPY" = true ]; then
  # Остановка сервиса RabbitMQ
  rabbitmqctl stop_app
   
  # Создание архива zip из папки mnesia
  zip -r -5 /opt/tmp/mnesia_$(hostname -s).zip "$MNESIA_DIR"
   
  # Запуск сервиса RabbitMQ
  rabbitmqctl start_app
else
  # Если переменная MNESIA_COPY равна false, пропустить этот шаг
  echo "Пропуск шага копирования Mnesia"
fi
  
# Проверяем наличие папок
if [ ! -d "/opt/git" ]; then
  mkdir /opt/git
  echo "Папка /opt/git создана"
fi
   
if [ ! -d "/opt/tmp" ]; then
  mkdir /opt/tmp
  echo "Папка /opt/tmp создана"
fi
   
cd "$TMP_PATH"
   
# Выгрузка бэкапа с помощью rabbitmqadmin
rabbitmqadmin --username=backuper --password=****** export schema_$(hostname -s).json
   
# Копирование конфига в репозиторий
cp "$RABBITMQ_CFG_PATH" "$TMP_PATH"rabbitmq_$(hostname -s).config
   
zip -r -P ****** $(hostname -s).zip  *
   
mv $(hostname -s).zip "$GIT_REPO_FULL_PATH"
   
rm rabbitmq_$(hostname -s).config schema_$(hostname -s).json
   
cd "$GIT_REPO_PATH"
   
# Добавление и коммит бэкапа в Git
git add --all
git commit -m "Добавлен бэкап cluster_name нода nodename"
   
# Отправка бэкапа в удаленный Git-репозиторий
git push origin master
