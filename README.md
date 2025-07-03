# 📦 Автоматизация публикации Reels через json2video (облачная версия)

Пожалуйста, **взаимодействуй со мной только на русском языке**.  
Названия кнопок интерфейса, нод и API оставляй на английском.

Этот README описывает настройку n8n workflow для генерации и автопостинга Instagram Reels **без ffmpeg и серверных файлов**. Весь процесс полностью облачный: от генерации текста до загрузки в соцсети.

---

## 🎯 Цель

Автоматизировать Reels с использованием:

- 📂 Google Drive (источник видео)
- 🧠 OpenAI (заголовки и описания)
- 🧱 json2video (рендеринг Reels с обводкой и текстом)
- 📢 autoposting.com (заливка Reels в Instagram)
- 🗂️ Airtable (учёт и логирование)

---

## ✅ Поток процесса

1. **Cron Trigger**  
   Стартует каждый день в 11:00 по МСК.

2. **GPT Generate**  
   Получает `title` и `description` для Reels (используется модель GPT через OpenAI API).

3. **Get Reels (Google Drive)**  
   Получает список видеофайлов (исходников) из заранее заданной папки на Google Диске.

4. **Pick Random**  
   Случайным образом выбирает один mp4-файл.

5. **Download from Drive**  
   Скачивает выбранное видео в бинарном формате (тип — `Binary`).

6. **Caption Source**  
   Извлекает текстовое описание (`title`, `description`) из предыдущей GPT-ноды.

---

## 🎬 Генерация видео через json2video

На этом этапе задача — **отправить URL выбранного видео** в сервис json2video, получить оттуда финальный отрендеренный ролик и использовать его для публикации.

### 🔗 Что нужно сделать

1. **Передать ссылку на видео**

   Сервис json2video ожидает публичный `videoUrl`, доступный без авторизации.  
   Для Google Drive это должен быть формат:

https://drive.google.com/uc?export=download&id=ID


Убедись, что в workflow есть нода, которая правильно формирует эту ссылку (например, через `Set` или `Function`).

2. **Создать видео через json2video**

Пример тела запроса:

```json
{
  "template": "reels-default-style",
  "inputs": {
    "videoUrl": "https://drive.google.com/uc?export=download&id=...",
    "title": "Твой заголовок",
    "description": "Описание к ролику"
  }
}
Заголовки запроса:

{
  "Content-Type": "application/json",
  "Authorization": "Bearer {{JSON2VIDEO_API_KEY}}"
}
Обработка projectId
В ответе от json2video приходит projectId.
Далее нужно следить за статусом рендера, запрашивая:

https://api.json2video.com/v2/movies/{{ $node["Create Video via json2video"].json["project"] }}
Дождись появления поля videoUrl — только после этого переходи к публикации.

Возможные подходы:

Цикл с Wait и IF
Простая задержка через Wait, если рендер стабильно занимает одинаковое время
Скачать готовое видео
После получения финального videoUrl:

либо скачай и сохрани на Google Drive (Upload)
либо напрямую передай его в autoposting.com
📢 Публикация в Instagram

Публикация выполняется через autoposting.com. Обязательно указывай:

видео (Binary или прямой videoUrl)
description (из GPT)
🗂 Хранение и логирование

✅ Google Drive
Сохраняется итоговое видео
✅ Airtable
Логируются:
📎 Ссылка на видео
📝 Описание
📆 Дата публикации
🕐 Расписание публикаций (25 роликов в день)

Публикации запускаются каждые 28 минут в период с 11:00 до 23:00 по МСК.

Используется:

{{ $item().index * 28 * 60 * 1000 }}
⚠️ Ошибки, которых стоит избегать

Неверный формат ссылки
Не все ссылки с Google Drive подходят.
Используй uc?export=download&id=...
Передача projectId в URL
Используй строго:

{{ $node["Create Video via json2video"].json["project"] }}
Публикация до завершения рендера
Не переходи к autoposting до появления videoUrl в json2video.
🔐 Переменные окружения

OPENAI_API_KEY=
JSON2VIDEO_API_KEY=
AUTOPOSTING_API_KEY=
AIRTABLE_API_KEY=
🤖 Используемые инструменты

Инструмент	Назначение
n8n	Автоматизация
json2video.com	Генерация видео из шаблонов
OpenAI GPT	Генерация текста
Google Drive	Хранение видео
autoposting.com	Загрузка Reels в Instagram
Airtable	Учёт и логирование
🧠 Примечания

Ты можешь заменить json2video на другой генератор, если он поддерживает шаблоны и API.
Публикацию можно адаптировать под Shorts, TikTok, VK Clips — достаточно сменить endpoint.
Автор

Алексей Кижаев
https://kizhay.ru
