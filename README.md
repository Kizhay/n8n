## 🚀 Развёртывание Workflow на сервере (Production)

🧠 Code review & Copilot instructions (for Codex):

🔹 Общайся со мной исключительно на русском языке.
🔹 Названия переменных, функций, узлов и свойств оставляй на оригинальном (английском) языке.
🔹 Не переводить технические элементы: названия API, таблиц, полей, типов данных и названия узлов n8n.
🔹 Объясняй ошибки и рекомендации кратко, без воды, в стиле технической поддержки.

Чтобы запустить workflow `reels-autopilot.json` на своём сервере (например, `kizhay.ru`), следуйте этим шагам:

### 1. **Установите Docker и Docker Compose**  
Убедитесь, что на сервере установлены Docker и Docker Compose.  
Для Ubuntu/Debian:
```sh
apt update && apt install -y docker.io docker-compose
```

### 2. **Убедитесь, что `ffmpeg` доступен внутри контейнера**  
В Dockerfile добавлена установка `ffmpeg`. Пример:
```Dockerfile
FROM n8nio/n8n:latest

USER root
RUN apk add --no-cache ffmpeg
USER node
```

Это гарантирует, что `ffmpeg` установлен в контейнере.

### 3. **Соберите и запустите n8n с помощью Docker Compose**  
В каталоге вашего проекта выполните:
```sh
docker-compose up --build -d
```

> Приложенный `docker-compose.yml` запустит n8n с поддержкой ffmpeg.

### 4. **Откройте интерфейс n8n**  
В браузере перейдите по адресу:  
👉 [https://kizhay.ru](https://kizhay.ru)

### 5. **Импортируйте Workflow**  
В интерфейсе n8n:
- Нажмите **«Create Workflow»**
- Выберите **«Import from File»**
- Укажите файл `reels-autopilot.json`

### 6. **Настройте учётные данные и переменные окружения**  
Убедитесь, что все узлы (например, Google Drive, Telegram) настроены с корректными учетными данными.  
При необходимости скорректируйте переменные, такие как пути к файлам, токены или вебхуки.

---

### ⚠️ ВАЖНО: настройка Fetch Competitor Reels1  
Для узла **Fetch Competitor Reels1** установите параметр **Response Format** в значение `String` в интерфейсе n8n.  
Страницы Instagram возвращают HTML, поэтому если оставить значение по умолчанию (`JSON`), возникнет ошибка.

---

✅ После выполнения этих шагов ваш сервер с n8n будет готов к запуску workflow `reels-autopilot` со всеми зависимостями.
