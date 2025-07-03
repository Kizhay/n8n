# 📦 Автоматизация публикации Reels через json2video (облачная версия)

Пожалуйста, **взаимодействуй со мной только на русском языке**.  
Названия кнопок интерфейса, нод и API оставляй на английском.

Этот README описывает настройку n8n workflow для генерации и автопостинга Instagram Reels **без ffmpeg и серверных файлов**. Весь процесс полностью облачный: от генерации текста до публикации Reels.

---

## 🎯 Цель

Автоматизировать Reels с использованием:

- 📂 Google Drive (видео)
- 🧠 OpenAI (заголовки и описания)
- 🧱 json2video (рендеринг)
- 📢 autoposting.com (заливка в соцсети)
- 🗂️ Airtable (учёт и логирование)

---

## ✅ Поток процесса

1. **Cron Trigger**  
   Стартует каждый день в 11:00 по Москве.

2. **GPT Generate (через CheckRequest)**  
   Генерирует `title` и `description` в формате Reels.

3. **Get Reels (Google Drive)**  
   Получает список видеофайлов из папки Google Диска.

4. **Pick Random**  
   Выбирает случайное видео из списка.

5. **Download from Drive**  
   Скачивает бинарное содержимое видео.

6. **Caption Source**  
   Извлекает `title` и `description` из ответа GPT.

7. **Create Video via json2video**  
   Отправляет видео и текст в json2video API.  
   Возвращает `projectId`.

8. **Check Render Status**  
   Дополнительная HTTP Request нода, которая опрашивает статус рендера по `projectId`, пока не появится `videoUrl` (ссылка на готовое видео).

9. **Save to Google Drive**  
   Загружает финальное видео в отдельную папку на Google Диске.

10. **Publish Reel (autoposting.com)**  
    Отправляет видео в Instagram Reels вместе с `description`.

11. **Save Record to Airtable**  
    Логирует публикацию в Airtable:

    - 📁 Ссылка на финальное видео (из Google Drive)
    - 📝 Description

---

## 🔧 Пример тела запроса в json2video

```json
{
  "template": "reels-default-style",
  "inputs": {
    "videoUrl": "https://drive.google.com/uc?id=...",
    "title": "Заголовок из GPT",
    "description": "Описание из GPT"
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

Публикации идут с 11:00 до 23:00 МСК с интервалом ~28 минут.

🔄 Механика:

- Используем `SplitInBatches`
- Внутри каждой итерации — `Wait` со скриптом:
  ```
  {{ $item().index * 28 * 60 * 1000 }}
  ```
- После паузы — публикация Reels

---

## 🗂 Хранение итогового видео и описания

**Рекомендуемые варианты:**

📁 **Google Drive** — для хранения финальных mp4 файлов  
📊 **Airtable** — логирует:

- Ссылку на видео
- Description

✅ Оба варианта позволяют быстро найти, скачать и переиспользовать ролики.

---

## 🔐 Переменные окружения

```
OPENAI_API_KEY
JSON2VIDEO_API_KEY
AUTOPOSTING_API_KEY
AIRTABLE_API_KEY
```

---

## 🧠 Примечания

- JSON2Video не возвращает `videoUrl` сразу — необходимо дождаться завершения рендера через дополнительный `GET` запрос.
- Только после этого можно:
  - Сохранить видео в Google Drive
  - Отправить его в Instagram через autoposting.com
  - Логировать в Airtable
- Описание (description) должно быть передано в теле запроса autoposting API.

---
