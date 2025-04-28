const express = require('express');
const os = require('os');
const app = express();
const port = process.env.PORT || 3000;

// Статус приложения
app.get('/status', (req, res) => {
  res.json({
    status: 'online',
    timestamp: new Date().toISOString(),
    hostname: os.hostname(),
    version: process.env.APP_VERSION || '1.0.0',
    uptime: process.uptime(),
    memory: process.memoryUsage(),
    cpu: os.cpus().length
  });
});

// Корневой маршрут
app.get('/', (req, res) => {
  res.send(`
    <html>
      <head>
        <title>CI/CD Demo Application</title>
        <style>
          body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
          h1 { color: #333; }
          .info { background-color: #f5f5f5; padding: 15px; border-radius: 5px; }
        </style>
      </head>
      <body>
        <h1>CI/CD Демонстрационное приложение</h1>
        <div class="info">
          <p>Версия: ${process.env.APP_VERSION || '1.0.0'}</p>
          <p>Хост: ${os.hostname()}</p>
          <p>Время запуска: ${new Date().toLocaleString()}</p>
        </div>
        <p>Это приложение развернуто с использованием автоматизированного CI/CD процесса.</p>
      </body>
    </html>
  `);
});

// Запуск сервера
app.listen(port, () => {
  console.log(`Приложение запущено на порту ${port}`);
});
