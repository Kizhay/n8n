# 📦 Workflow: reels-autopilot (Production)

Сервер `n8n` развёрнут по адресу:  
👉 [https://kizhay.ru](https://kizhay.ru)

Workflow `reels-autopilot` выполняется **только на этом сервере**.  
Импорт файла `reels-autopilot.json` не требуется — он уже загружен и активен.

---

## 🧠 Инструкции для поддержки и Copilot

🔹 Общайся исключительно на русском языке.  
🔹 Названия переменных, функций, узлов и свойств оставляй на английском.  
🔹 Не переводить API, поля, таблицы, узлы n8n.  
🔹 Ошибки и рекомендации — кратко, строго по сути.

---

## ⚙️ Требования к серверу

### 1. Установи `ffmpeg`

Убедись, что `ffmpeg` установлен и работает:

```bash
ffmpeg -version
```

Если не установлен:

```bash
sudo apt update && sudo apt install -y ffmpeg
```

---

## 🧩 Настройка узлов Workflow

### 2. `Download from Drive1` → `Write Binary File`

Скачивание файла из Google Drive происходит в бинарном виде.  
Чтобы ffmpeg получил путь к файлу — добавь узел **Write Binary File**:

**Параметры узла:**

* `File Name:` `/tmp/input.mp4`  
* `Property Name:` `data`

Этот узел запишет видеофайл на диск сервера.

---

### 3. `Add Frame`: команда ffmpeg

**Важно:** команда должна быть в одной строке — без `\n`.

Пример:

```bash
ffmpeg -i "/tmp/input.mp4" -vf "drawbox=...,drawtext=text='{{$node[\"Caption Source\"].json[\"title\"]}}'" -y "/tmp/output.mp4"
```

* Не используйте `{{$node["Download from Drive1"].binary.data.filePath}}` — такого пути нет.  
* Используй путь из `Write Binary File`: `/tmp/input.mp4`

---

### 4. `Caption Source`

Заголовок берётся из узла `Caption Source`.  
Убедись, что он возвращает корректное значение `title`.

---

### 5. `Telegram` или `Upload Reel`

Если ты публикуешь ролик, убедись, что путь `/tmp/output.mp4` существует.  
Можно добавить узел `Read Binary File` или `Move Binary Data`, если нужно переслать файл другим узлам.

---

## 🔑 Учётные данные и переменные

Проверь, что все узлы подключены к рабочим API:

* `Google Drive`
* `Airtable`
* `OpenAI`
* `Telegram`
* `Threads` (если используется)

Если есть `.env` — проверь токены, ID и пути.

---

## ⚠️ ВАЖНО: Fetch Competitor Reels1

Узел `Fetch Competitor Reels1` получает HTML со страниц Instagram.  
Поэтому:

* **Response Format**: `String`  
* Если оставить `JSON`, будет ошибка: `Unexpected token < in JSON at position 0`

---

## 🧯 Типовые ошибки и решения

| Ошибка                                                       | Причина                                           | Решение                                                             |
| ------------------------------------------------------------ | ------------------------------------------------- | ------------------------------------------------------------------- |
| `ffmpeg -i ""`                                               | Узел `Write Binary File` отсутствует              | Добавь `Write Binary File`, пропиши `fileName: /tmp/input.mp4`      |
| `ENOENT: no such file or directory, open '/files/input.mp4'` | Указан путь внутри Docker или несуществующий путь | Используй `/tmp/input.mp4` на сервере                               |
| `-vf: not found`                                             | В ffmpeg-команде использован перенос строки `\n`  | Напиши команду в одну строку                                        |
| `SSL certificate error`                                      | Сертификат сервера отклонён                       | Для теста: `export NODE_TLS_REJECT_UNAUTHORIZED=0` (⚠️ небезопасно) |
| `Caption Source` не выдаёт title                             | Неправильная структура JSON                       | Проверь, есть ли `json.title`                                       |

---

## ✅ После настройки

После выполнения всех шагов Workflow будет стабильно работать на `https://kizhay.ru`:

* Загружать видео из Google Drive  
* Сохранять файл на сервер  
* Накладывать текст через `ffmpeg`  
* Публиковать/отправлять итоговое видео

---

👨‍🔧 Если понадобится, добавим шаги для логирования, резервного копирования или мониторинга процессов.
