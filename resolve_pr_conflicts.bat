@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

echo [1/6] Проверка git...
where git >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Git не найден в PATH.
  pause
  exit /b 1
)

echo [2/6] Получение изменений с origin...
git fetch origin --prune
if errorlevel 1 (
  echo [ERROR] Не удалось выполнить git fetch origin.
  echo Проверьте remote и доступ к репозиторию.
  pause
  exit /b 1
)

for /f %%b in ('git rev-parse --abbrev-ref HEAD') do set CUR_BRANCH=%%b
set BASE=origin/main

git show-ref --verify --quiet refs/remotes/origin/main
if errorlevel 1 (
  set BASE=origin/master
)

git show-ref --verify --quiet refs/remotes/%BASE%
if errorlevel 1 (
  echo [ERROR] Не найдено origin/main или origin/master.
  echo Укажите базовую ветку вручную:
  echo   git merge origin/ИМЯ_БАЗОВОЙ_ВЕТКИ
  pause
  exit /b 1
)

echo [3/6] Текущая ветка: %CUR_BRANCH%
echo [4/6] Базовая ветка: %BASE%

echo [5/6] Пробую rebase (меньше лишних merge-коммитов)...
git rebase %BASE%
if not errorlevel 1 goto :ok

echo [WARN] Rebase привёл к конфликтам. Откатываю rebase...
git rebase --abort >nul 2>&1

echo [6/6] Пробую обычный merge...
git merge %BASE%
if errorlevel 1 (
  echo.
  echo [CONFLICT] Есть конфликты. Это нормально — нужно разрешить их вручную.
  echo 1) Откройте файлы с маркерами ^<^<^<^<^<^<^< / ======= / ^>^>^>^>^>^>^>
  echo 2) Исправьте текст
  echo 3) Выполните: git add .
  echo 4) Выполните: git commit
  echo 5) Выполните: git push
  echo.
  git status --short
  pause
  exit /b 1
)

:ok
echo [OK] Ветка синхронизирована с %BASE%.
echo Проверьте и отправьте изменения:
echo   git push
pause
