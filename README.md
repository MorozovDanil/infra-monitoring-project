# Итоговое домашнее задание
Морозов Данил Алексеевич РИМ-160890к

## О проекте

- Проверка доступности API, генерация и анализ тестовых логов
- Сервис hashicorp/http-echo работает за прокси nginx в Docker Compose
- GitHub Actions проверяет Bash-скрипты и запускает тесты доступности API

## Требования

- Bash
- Curl
- Docker Engine с плагином Docker Compose
- Git

## Запуск Bash-скриптов
Команды выполняются из корня проекта
```sh
chmod +x check_api.sh analyze_logs.sh # делает скрипты исполняемыми
./check_api.sh https://httpbin.org/status/200 # при HTTP-коде 200 выводит "API доступен"
./check_api.sh https://httpbin.org/status/404 # пример с кодом-ошибкой 404
./analyze_logs.sh # сгенерировать и проанализировать тестовый лог
```

Скрипт создаёт access.log из 300 записей и выводит общее количество запросов, топ-3 IP-адреса и количество ответов 4xx и 5xx. При каждом запуске access.log перезаписывается.

## Запуск Docker Compose
Команды выполняются из корня проекта

```sh
sudo docker compose up -d # запуск
sudo docker compose ps # проверка
curl http://localhost:80
sudo docker compose logs --tail=50 api proxy # просмотр логов
sudo docker compose down # удаление контейнеров проекта и его сети
```

Сервис proxy принимает запросы на порту 80 и передаёт их сервису api на порт 8080. Оба контейнера подключены к общей сети monitoring.

## Передача проекта на сервер через SSH/SCP

```sh
# создание ключа
ssh-keygen -t ed25519 -f ~/.ssh/infra_monitoring
# копирование ключа на сервер
ssh-copy-id -i ~/.ssh/infra_monitoring.pub deploy@server.example.com
# (из корня проекта) создать архив и передать на сервер
tar -czf /tmp/infra-monitoring-project.tar.gz README.md .gitignore check_api.sh analyze_logs.sh docker-compose.yml nginx.conf .github
scp -i ~/.ssh/infra_monitoring /tmp/infra-monitoring-project.tar.gz deploy@server.example.com:~/
# подключение на сервер
ssh -i ~/.ssh/infra_monitoring deploy@server.example.com
# распаковка на сервере
mkdir -p ~/infra-monitoring-project
tar -xzf ~/infra-monitoring-project.tar.gz -C ~/infra-monitoring-project
cd ~/infra-monitoring-project
sudo docker compose up -d
curl http://localhost:80
```
