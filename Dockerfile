# Этап сборки
FROM node:16-alpine AS builder

# Устанавливаю рабочую директорию
WORKDIR /app

# Копирую файлы для установки зависимостей (package.json и package-lock.json, если есть)
# Если package-lock.json отсутствует, скопируется только package.json
COPY package*.json ./

# Устанавливаю зависимости
# ИСПРАВЛЕНИЕ: Заменено 'npm ci' на 'npm install', чтобы не требовать package-lock.json
RUN npm install --only=production

# Второй этап - минимальный образ для запуска
FROM node:16-alpine

# Задаю метаданные образа
LABEL maintainer="**ФИО***"
LABEL description="Демонстрационное приложение CI/CD"
LABEL version="1.0.0"

# Создаю непривилегированного пользователя
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Устанавливаю рабочую директорию
WORKDIR /app

# Копирую зависимости из этапа сборки
COPY --from=builder /app/node_modules ./node_modules

# Копирую исходный код
COPY . .

# Задаю переменные окружения
ENV NODE_ENV=production
ENV PORT=3000
# Обратите внимание: APP_VERSION=1.0.0 здесь статичен. 
# Если вы хотите использовать версию из workflow, нужно передать ее как build-arg.
# В workflow вы уже передаете APP_VERSION, так что этот ENV можно удалить или оставить
# как значение по умолчанию, если build-arg не передан.
# ENV APP_VERSION=1.0.0 

# Проверка доступности приложения
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:$PORT/status || exit 1

# Открываю порт
EXPOSE $PORT

# Переключаюсь на непривилегированного пользователя
USER appuser

# Запускаю приложение
CMD ["node", "app.js"]
