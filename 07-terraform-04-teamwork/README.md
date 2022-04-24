# Домашнее задание к занятию "7.4. Средства командной работы над инфраструктурой."

## Задача 1. Настроить terraform cloud (необязательно, но крайне желательно)

Доступ к ресурсу заблокирован:
![1](https://user-images.githubusercontent.com/87389868/164885800-baf944b5-6a28-4c91-ab29-702bba8a352e.JPG)


## Задача 2. Написать серверный конфиг для атлантиса

[atlantis.yaml](atlantis/atlantis.yaml)
[server.yaml](atlantis/server.yaml)


## Задача 3. Знакомство с каталогом модулей

Использование модулей позволяет уменьшить количество используемого кода. Часто используемые ресурсы эфертивней вынести в одтельный модуль и при необходимости обращаться к нему.

Попробовал создать собственные "модули" (подключаемые файлы формата tf). Явных ошибок в коде нет, но при запуске terraform init возникает ошибка проверки плагина.

```
Initializing modules...

Initializing the backend...

Initializing provider plugins...
- Finding latest version of terraform-registry.storage.yandexcloud.net/yandex-cloud/yandex...
- Finding latest version of hashicorp/yandex...
- Installing terraform-registry.storage.yandexcloud.net/yandex-cloud/yandex v0.72.0...
- Installed terraform-registry.storage.yandexcloud.net/yandex-cloud/yandex v0.72.0 (self-signed, key ID E40F590B50BB8E40)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html
╷
│ Error: Failed to query available provider packages
│
│ Could not retrieve the list of available versions for provider hashicorp/yandex: could not connect to registry.terraform.io: Failed to request discovery document: 403 Forbidden
```

[Файл конфигурации](terraform)