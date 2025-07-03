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

7. **Create Video via json2video**  
   Отправляет запрос на json2video API:

   - загружает `videoUrl`
   - передаёт `title`, `description`
   - получает `projectId`

8. **Check Render Status**  
   Периодически запрашивает статус рендера:

   ```js
   https://api.json2video.com/v2/movies/{{ $node["Create Video via json2video"].json["project"] }}
   ```

   Ждёт появления `videoUrl` (финального рендера).

9. **Save to Google Drive**  
   Загружает готовое видео в другую папку на диске (например, `reels-final`).

10. **Publish Reel (autoposting.com)**  
    Отправляет видео в Instagram Reels.  
    Обязательно передаётся `description`.

11. **Save Record to Airtable**  
    Логирует:

    - ссылку на итоговое видео (Google Drive)
    - описание (description)
    - дату публикации

---

## 🔧 Пример тела запроса в json2video

```json
{
  "template": "reels-default-style",
  "inputs": {
    "videoUrl": "https://drive.google.com/uc?id=...",
    "title": "Твой заголовок",
    "description": "Описание к ролику"
  }
}
```

## 📋 Заголовки запроса к json2video

```json
{
  "Content-Type": "application/json",
  "Authorization": "Bearer {{JSON2VIDEO_API_KEY}}"
}
```

---

## 🕐 Расписание публикаций (25 роликов в день)

Публикации запускаются каждые **28 минут** в период **с 11:00 до 23:00 по МСК**:

- Используется `SplitInBatches`
- Внутри каждой итерации: `Wait` с формулой паузы

```js
{{ $item().index * 28 * 60 * 1000 }}
```

---

## 🗂 Хранение и логирование

### ✅ Google Drive

- Сохраняется итоговое видео
- Удобно для ручного доступа к файлам

### ✅ Airtable

- Логируются все публикации:
  - 📎 Ссылка на финальный mp4
  - 📝 Описание (description)
  - 🕒 Дата

---

## ⚠️ Ошибки, которых стоит избегать

1. **Неверная подстановка projectId в URL**  
   Используй только синтаксис:

   ```js
   {{ $node["Create Video via json2video"].json["project"] }}
   ```

   ❌ Не используй `="https://..." + $node[...]` — это невалидно в поле URL.

2. **Отправка видео до завершения рендера**  
   Убедись, что поле `videoUrl` появилось в ответе json2video перед переходом к Google Drive и autoposting.

---

## 🔐 Переменные окружения

```env
OPENAI_API_KEY=
JSON2VIDEO_API_KEY=
AUTOPOSTING_API_KEY=
AIRTABLE_API_KEY=
```

---

## 🤖 Используемые инструменты

| Инструмент          | Назначение                   |
|---------------------|------------------------------|
| **n8n**             | Автоматизация                |
| **json2video.com**  | Генерация видео из шаблонов  |
| **OpenAI GPT**      | Генерация текста             |
| **Google Drive**    | Хранение видео               |
| **autoposting.com** | Загрузка Reels в Instagram   |
| **Airtable**        | Учёт и логирование           |

---

## 🧠 Примечания

- Ты можешь заменить json2video на любой другой видеогенератор, поддерживающий шаблоны и API.
- Публикацию можно адаптировать и под TikTok, Shorts, VK Clips — просто поменяй API в Publish-ноде.

---

## Автор

Алексей Кижаев  
[https://kizhay.ru](https://kizhay.ru)
