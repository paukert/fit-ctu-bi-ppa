# Sudoku solver (BI-PPA)

Programming Paradigms course at FIT CTU (2020/2021). This repository contains my semestral work – sudoku solver written in prolog.

Input example:
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

Following predicates are prepared for testing:
- `solve(<Sudoku>)` – finds and prints solution for given sudoku (if exists)
- `sudoku_1.` – 1st testing sudoku
- `sudoku_2.` – 2nd testing sudoku
- `sudoku_3.` – 3rd testing sudoku
- `sudoku_4.` – 4th testing sudoku
- `sudoku_5.` – 5th testing sudoku (empty sudoku)
- `sudoku_6.` – 6th testing sudoku (anti-brute-force sudoku)
- `tests.` – runs all tests to verify functionality
