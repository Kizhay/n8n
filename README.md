# 📦 Workflow: reels-autopilot (Production)

Сервер n8n развёрнут по адресу [https://kizhay.ru](https://kizhay.ru).
Workflow `reels-autopilot` уже загружен и активен — импортировать файл `reels-autopilot.json` не нужно.

---

## Требования

### 1. Установка ffmpeg

Убедитесь, что `ffmpeg` установлен:

```bash
ffmpeg -version
```

Если команда не найдена, выполните:

- **Linux (apt):**

  ```bash
  sudo apt update && sudo apt install -y ffmpeg
  ```

- **macOS (brew):**

  ```bash
  brew install ffmpeg
  ```

---

## Запуск Docker

Соберите и запустите контейнер:

```bash
docker compose up --build
```

Данные n8n сохраняются в каталоге `n8n-data`.

---

## Настройка узлов Workflow

1. **Download from Drive1 → Write Binary File**

   - `File Name: /tmp/input.mp4`
   - `Property Name: data`

   Этот узел сохраняет видеофайл на диск.

2. **Add Frame** — команда ffmpeg (обязательно одной строкой):

   ```bash
   ffmpeg -i "/tmp/input.mp4" -vf "drawbox=...,drawtext=text='{{$node[\"Caption Source1\"].json[\"title\"]}}'" -y "/tmp/output.mp4"
   ```

3. **Generate Caption → Generate Title**

   Используйте ChatGPT для кликбейтного заголовка и описания. Узел `Caption Source` должен выдавать поле `title`.

4. **Generate Random Publish Time (11:00 - 21:00) → Wait**

   Добавьте задержку от 30 минут до 2 часов перед публикацией.

---

## Что делает Workflow

- Загружает видео из Google Drive.
- Сохраняет файл в `/tmp/input.mp4`.
- Накладывает текст через ffmpeg и создаёт `/tmp/output.mp4`.
- Публикует или отправляет итоговое видео.

---

