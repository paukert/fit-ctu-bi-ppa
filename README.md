# Sudoku solver (BI-PPA)

Tento projekt vznikl jako semestrální práce v předmětu BI-PPA v akademickém roce 2020/2021.

Sudoku se zadává jako seznam (= celé sudoku) seznamů (= řádky), prázdná políčka obsahují `_`

```prolog
[
    [_, _, 1,    4, _, 6,    8, _, _],
    [5, _, _,    2, _, 8,    _, _, 9],
    [9, 4, _,    5, _, 7,    _, 2, 1],

    [8, _, 4,    _, _, _,    9, _, 5],
    [_, _, _,    _, _, _,    _, _, _],
    [6, _, 2,    _, _, _,    3, _, 8],

    [2, 8, _,    7, _, 5,    _, 3, 6],
    [4, _, _,    6, _, 3,    _, _, 7],
    [_, _, 7,    1, _, 9,    5, _, _]

]
```

Po zadání `solve(<Sudoku>)` se řešení vypíše do terminálu (pokud existuje).

Pro potřeby odevzdání, vývoje a testování jsou předpřipraveny následující predikáty:
- `sudoku_1.` – 1. testovací sudoku
- `sudoku_2.` – 2. testovací sudoku
- `sudoku_3.` – 3. testovací sudoku
- `sudoku_4.` – 4. testovací sudoku
- `tests.` – spustí testy pro ověření funkčnosti jednotlivých predikátů
