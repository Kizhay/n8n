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
   Результат — готовое видео с:

   - 🟥 Чёрной рамкой сверху и снизу
   - 🔠 Заголовком (`title`) в верхней рамке
   - 📝 Описание (`description`) внутри caption

   **Пример тела запроса:**
   ```json
   {
     "template": "reels-default-style",
     "inputs": {
       "videoUrl": "https://drive.google.com/uc?id=...",
       "title": "Заголовок из GPT",
       "description": "Описание из GPT"
     }
   }
Заголовки запроса:

{
  "Content-Type": "application/json",
  "Authorization": "Bearer {{JSON2VIDEO_API_KEY}}"
}
Check Duplicate
Проверка в Airtable: не было ли уже этого видео.
Publish Reel
Отправка видео и description в autoposting.com (через API).
Save Record
Логирует публикацию в Airtable: название файла, caption, дата.
🕐 Расписание публикаций (25 роликов в день)

Публикации идут с 11:00 до 23:00 МСК с интервалом ~28 минут.

🔄 Механика:
Используем SplitInBatches
Внутри каждой итерации — Wait со скриптом:
{{ $item().index * 28 * 60 * 1000 }}
После паузы — публикация Reels
💡 Это позволяет выложить 25 видео равномерно за 12 часов.

🗂 Хранение итогового видео и описания

Рекомендуемые варианты:

📁 Google Drive — для хранения mp4 (можно отправлять прямо с json2video)
📊 Airtable — логирует описание + ссылку на финальное видео
✅ Оба варианта позволяют быстро найти, скачать и переиспользовать ролик
🔐 Переменные окружения

OPENAI_API_KEY
JSON2VIDEO_API_KEY
AUTOPOSTING_API_KEY
AIRTABLE_API_KEY
