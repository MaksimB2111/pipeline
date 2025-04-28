# Этап сборки
FROM node:16-alpine AS builder

# Устанавливаю рабочую директорию
WORKDIR /app

# Копирую файлы для установки зависимостей
COPY package*.json ./

# Устанавливаю зависимости
RUN npm ci --only=production

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
ENV APP_VERSION=1.0.0

# Проверка доступности приложения
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:$PORT/status || exit 1

# Открываю порт
EXPOSE $PORT

# Переключаюсь на непривилегированного пользователя
USER appuser

# Запускаю приложение
CMD ["node", "app.js"]
