# PR не мержится (Branch has merge conflicts) — что делать

Если в GitHub PR вы видите `Branch has merge conflicts`, это не ошибка приложения.
Это значит, что в вашей ветке и в базовой ветке изменены одинаковые строки.

## Быстрое решение (Windows)
1. Откройте папку репозитория.
2. Запустите `resolve_pr_conflicts.bat`.
3. Если есть конфликты — исправьте файлы и выполните:
   - `git add .`
   - `git commit`
   - `git push`

## Ручной вариант
```bash
git fetch origin --prune
git rebase origin/main
# если конфликт:
# исправить файлы -> git add . -> git rebase --continue
# или отказаться: git rebase --abort
```

После push GitHub обновит PR и конфликт исчезнет.
