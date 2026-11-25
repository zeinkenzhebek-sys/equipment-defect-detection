# Equipment Defect Detection

Жоба машиналық оқыту негізінде өнеркәсіптік жабдықтардың суреттерінен ақауларды (жарықшақ, тот, деформация) автоматты түрде анықтайтын компьютерлік көру жүйесін әзірлейді. Жүйе өндірістегі оператор мен техникалық қызмет инженеріне арналған.

## Мақсаты

Жабдықты қолмен тексеруді автоматтандырып, ақауларды ерте және дәл анықтау.

## Пайдаланушылар

- Оператор
- Инженер
- Әкімші

## Талаптар

1. Оператор жабдықтың суретін жүйеге жүктейді.
2. Жүйе сурет сапасын (өлшемі, анықтығы) тексереді.
3. Жүйе ML-модельдің көмегімен суреттегі ақауларды анықтайды.
4. Жүйе ақау түрін және оның орнын (bounding box) суретте белгілейді.
5. Жүйе тексеру нәтижесін деректер базасына сақтайды.
6. Инженер тексеру тарихын қарап, ақау бойынша есеп алады.
7. Жүйе ақау табылған жағдайда инженерге хабарлама жібереді.
8. Әкімші ML-модельдің нұсқасын жаңартады және пайдаланушыларды басқарады.

## Құжаттама

- [Activity: ақауды анықтау](docs/analysis/activity-detect-defect.png)
- [Sequence: ақауды анықтау](docs/analysis/sequence-detect-defect.png)
- [DFD контекстік диаграммасы](docs/analysis/dfd-context.png)
- [DFD 0-деңгей](docs/analysis/dfd-level0.png)
- [DFD 1-деңгей](docs/analysis/dfd-level1.png)
- [ERD диаграммасы](docs/database/erd.png)
- [SQL схема](docs/database/schema.sql)
- [Сұраныс нәтижелері](docs/database/query-results.png)

## Интерфейс

* **Навигация диаграммасы:** [navigation.drawio.png](docs/ui/navigation.drawio.png) | [navigation.drawio](docs/ui/navigation.drawio)
* **Экран макеттері:**
  * [01-login.png](docs/ui/screens/01-login.png)
  * [02-home.png](docs/ui/screens/02-home.png)
  * [03-upload-inspect.png](docs/ui/screens/03-upload-inspect.png)
  * [04-defect-result.png](docs/ui/screens/04-defect-result.png)
  * [05-history-list.png](docs/ui/screens/05-history-list.png)
  * [06-admin-profile.png](docs/ui/screens/06-admin-profile.png)
* **Интерфейсті бағалау:** [evaluation.md](docs/ui/evaluation.md)

### Түстер кестесі

| Атауы / Күйі | Түсі | HEX коды | Қолданылуы |
| :--- | :--- | :--- | :--- |
| Негізгі түс | Қою көк | `#1E3A8A` | Негізгі батырмалар және навигация |
| Фон | Ашық сұр-ақ | `#F8FAFC` | Экран фоны мен карточкалар |
| Жоғары дәлдік / Белсенді (`confidence >= 0.900`, `is_active = TRUE`) | Жасыл | `#16A34A` | Жоғары сенімділік (`0.912`, `0.955`) және белсенді `v2.0` моделі |
| Орташа дәлдік (`0.800 <= confidence < 0.900`) | Сары | `#EAB308` | Орташа сенімділік (`0.847`, `0.823`) |
| Төмен дәлдік / Қате (`confidence < 0.800` немесе `alt` қатесі) | Қызыл | `#DC2626` | Төмен дәлдік (`0.781`), өріс тексерулері және қате хабарламалары |

### Сәйкестік кестесі

| Экран | Талап нөмірі | Кесте (`schema.sql`) | Бағандар / Деректер |
| :--- | :--- | :--- | :--- |
| `01-login.png` | Т1–Т8 | `users`, `roles` | `email`, `role_id`, `role_name` |
| `02-home.png` | Т1, Т6, Т7 | `equipment`, `equipment_assignments`, `inspections` | `equipment_id`, `name`, `location`, `assigned_date` |
| `03-upload-inspect.png` | Т1–Т5 | `inspections` | `equipment_id`, `user_id`, `model_id`, `image_path`, `inspected_at` |
| `04-defect-result.png` | Т3–Т5, Т7 | `defects`, `ml_models` | `defect_id`, `inspection_id`, `x`, `y`, `width`, `height`, `confidence`, `version` |
| `05-history-list.png` | Т5, Т6 | `inspections`, `defects`, `equipment`, `users` | 13-аптадағы `INSERT` деректері (`conv_001.jpg`, `pipe_001.jpg`, `press_001.jpg`, `conv_002.jpg`, ақаулар 1–5) |
| `06-admin-profile.png` | Т8 | `ml_models`, `users`, `roles` | `model_id`, `version`, `trained_at`, `is_active`, `full_name`, `email`, `role_name` |
