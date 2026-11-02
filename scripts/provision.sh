#!/usr/bin/env bash
# ==============================================================================
# Mini DevOps Stand - Automated Provisioning Script
# Supported OS: AlmaLinux 9 / RHEL 9 / Rocky Linux 9
# ==============================================================================
set -euo pipefail

echo "[1/5] Установка веб-сервера Nginx..."
sudo dnf install -y nginx

echo "[2/5] Включение и запуск сервиса Nginx..."
sudo systemctl enable --now nginx

echo "[3/5] Настройка межсетевого экрана (firewalld)..."
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --reload

echo "[4/5] Развертывание кастомной веб-страницы и SVG-логотипа..."
sudo tee /usr/share/nginx/html/logo.svg > /dev/null << 'SVG_EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 400" width="100%" height="100%">
  <defs>
    <linearGradient id="devopsGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#38bdf8"/>
      <stop offset="50%" stop-color="#818cf8"/>
      <stop offset="100%" stop-color="#c084fc"/>
    </linearGradient>
  </defs>
  <path d="M 250,200 C 120,70 50,150 50,200 C 50,250 120,330 250,200 C 380,70 450,150 450,200 C 450,250 380,330 250,200 Z" 
        fill="none" stroke="url(#devopsGrad)" stroke-width="32" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M 550,200 C 420,70 350,150 350,200 C 350,250 420,330 550,200 C 680,70 750,150 750,200 C 750,250 680,330 550,200 Z" 
        fill="none" stroke="url(#devopsGrad)" stroke-width="32" stroke-linecap="round" stroke-linejoin="round"/>
  <text x="400" y="370" font-family="sans-serif" font-size="34" font-weight="bold" fill="#f8fafc" text-anchor="middle">ALMALINUX DEVOPS STAND</text>
</svg>
SVG_EOF

sudo tee /usr/share/nginx/html/index.html > /dev/null << 'HTML_EOF'
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Mini DevOps Stand</title>
    <style>
        body { font-family: sans-serif; text-align: center; background: #0f172a; color: white; padding-top: 50px; }
        h1 { color: #38bdf8; font-size: 32px; }
        p { color: #94a3b8; font-size: 18px; }
        img { width: 550px; max-width: 90%; }
    </style>
</head>
<body>
    <h1>Mini DevOps Stand is Running!</h1>
    <p>Automated via provision.sh on AlmaLinux 9</p>
    <img src="logo.svg" alt="DevOps Logo">
</body>
</html>
HTML_EOF

echo "[5/5] Корректировка прав и контекстов безопасности SELinux..."
sudo chmod 644 /usr/share/nginx/html/index.html /usr/share/nginx/html/logo.svg
sudo restorecon -Rv /usr/share/nginx/html

echo "=== Стенд успешно развернут и готов к работе! ==="
