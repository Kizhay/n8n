# 📦 Автоматизация публикации Reels через json2video (облачная версия)

Этот README описывает настройку n8n workflow для генерации и автопостинга Instagram Reels **без ffmpeg и работы с файлами на сервере**. Все действия происходят в облаке: от загрузки видео до публикации.

---

## 🎯 Цель

Автоматизировать Reels с использованием:

* 📂 Облачного хранилища (Google Drive)
* 🧠 Генерации текста с помощью OpenAI
* 🧱 Рендеринга видео через API `json2video`
* 📢 Автопубликации через `autoposting.com`
* 🗂️ Учёта и логгирования публикаций через Airtable

---

## ✅ Поток процесса

1. **Cron Trigger**
   Запускает рабочий процесс по расписанию.

2. **Get Reels (Google Drive)**
   Получает список доступных видео из указанной папки.

3. **Pick Random**
   Выбирает одно случайное видео из списка.

4. **Download from Drive**
   Загружает бинарное содержимое видео.

5. **GPT Generate**
   Генерирует `title` и `description` в стиле сценария для Reels.

6. **Caption Source**
   Извлекает `title` и `description` из ответа GPT.

7. **Create Video via json2video**
   Отправляет оригинальное видео и сгенерированные подписи на API `json2video`, который возвращает оформленный финальный ролик. Используется HTTP-запрос POST с телом в формате JSON:

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

   ⚙️ **Технические детали:**

   * Метод: `POST`
   * URL: `https://api.json2video.com/render`
   * Заголовки:

     ```json
     {
       "Content-Type": "application/json",
       "Authorization": "Bearer {{JSON2VIDEO_API_KEY}}"
     }
     ```
   * Ответ: ссылка на `.mp4` файл или бинарный файл (в зависимости от настроек API)
   * Результат нужно передать как бинарные данные в следующий шаг (`Publish Reel`)

   💬 **Важно:**
   Убедитесь, что:

   * API-ключ передаётся через `Authorization` в Headers
   * URL оригинального видео (`videoUrl`) должен быть публично доступным
   * Шаблон `reels-default-style` заранее создан в аккаунте json2video
   * Параметры `title` и `description` вставляются из ноды `Caption Source`

8. **Check Duplicate**
   Проверяет Airtable: не публиковали ли уже это видео

9. **Publish Reel**
   Отправляет финальное видео и подпись на API `autoposting.com`

10. **Save Record**
    Записывает факт публикации в Airtable

---

## 📥 Интеграции

* **Google Drive** — источник видео (папка должна быть общедоступной или доступной через OAuth)
* **OpenAI GPT** — генерация title и description
* **json2video** — визуальная обработка видео (авторизация по API ключу)
* **autoposting.com** — финальная публикация Reels (авторизация по API ключу)
* **Airtable** — база для логирования публикаций

---

## 🛠 Переменные окружения

* `OPENAI_API_KEY`
* `JSON2VIDEO_API_KEY`
* `AUTOPOSTING_API_KEY`
* `AIRTABLE_API_KEY`

---

## 🌐 Язык взаимодействия с Codex

Пожалуйста, взаимодействуй со мной **исключительно на русском языке**.
Оставляй **оригинальные английские названия** только для кнопок интерфейса, названий API, названий нод и параметров JSON.
