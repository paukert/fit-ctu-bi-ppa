% solve(+Sudoku)
solve(Sudoku) :-
    validate(Sudoku), !,
    solve(Sudoku, Sudoku, 0), !,
    print(Sudoku).

% solve(+Sudoku, +Sudoku, +RowIndex)
solve([], _, _).
solve([Row | Tail], Sudoku, RowIndex) :-
    solve_row(Row, Sudoku, 0, RowIndex),
    N is RowIndex + 1,
    solve(Tail, Sudoku, N).

% print(+Solution)
print([]).
print([Row | Tail]) :- writeln(Row), print(Tail).

% remove(+RemoveFrom, +ElementsToRemove, -Result)
remove([], _, []).
remove([H | Tail], ElementsToRemove, Result) :- member(H, ElementsToRemove), !, remove(Tail, ElementsToRemove, Result).
remove([H | Tail], ElementsToRemove, [H | Result]):- remove(Tail, ElementsToRemove, Result).

% solve_row(+Row, +Sudoku, +ColumnIndex, +RowIndex)
solve_row([], _, _, _).
solve_row([Element | Tail], Sudoku, ColumnIndex, RowIndex) :-
    nonvar(Element),
    !,
    N is ColumnIndex + 1,
    solve_row(Tail, Sudoku, N, RowIndex).

solve_row([Element | Tail], Sudoku, ColumnIndex, RowIndex) :-
    AvaibleNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9],
    nth_row(Sudoku, RowIndex, CurrentRow),
    nth_column(Sudoku, ColumnIndex, CurrentColumn),
    get_square(Sudoku, ColumnIndex, RowIndex, CurrentSquare),
    remove(AvaibleNumbers, CurrentRow, AvaibleNumbers1),
    remove(AvaibleNumbers1, CurrentColumn, AvaibleNumbers2),
    remove(AvaibleNumbers2, CurrentSquare, PossibleNumbers),
    member(Element, PossibleNumbers),
    N is ColumnIndex + 1,
    solve_row(Tail, Sudoku, N, RowIndex).

% nth_row(+Matrix, +RowIndex, -Result)
nth_row(Matrix, RowIndex, Result) :- nth_element(Matrix, RowIndex, SubResult), delete_vars(SubResult, Result).

% delete_vars(+List, -Result)
delete_vars([], []).
delete_vars([H | Tail], Result) :- var(H), !, delete_vars(Tail, Result).
delete_vars([H | Tail], [H | Result]) :- delete_vars(Tail, Result).

% nth_element(+List, +Index, -Result)
nth_element([H | _], 0, H) :- !.
nth_element([_ | Tail], Index, Result) :- N is Index - 1, nth_element(Tail, N, Result).

% nth_column(+Matrix, +Index, -Column)
nth_column(Matrix, Index, Result) :- nth_column_with_vars(Matrix, Index, SubResult), delete_vars(SubResult, Result).

% nth_column_with_vars(+Matrix, +ColumnIndex, -Column)
nth_column_with_vars([], _, []).
nth_column_with_vars([Row | Tail], ColumnIndex, [NthElement | Result]) :-
    nth_element(Row, ColumnIndex, NthElement),
    nth_column(Tail, ColumnIndex, Result).

% get_square(+Matrix, +ColumnIndex, +RowIndex, -SubMatrix)
get_square([_, _, _ | Tail], ColumnIndex, RowIndex, SubMatrix) :-
    RowIndex > 2,
    !,
    N is RowIndex - 3,
    get_square(Tail, ColumnIndex, N, SubMatrix).

get_square([[_, _, _ | Tail1] | [[_, _, _ | Tail2] | [[_, _, _ | Tail3] | _]]], ColumnIndex, RowIndex, SubMatrix) :-
    ColumnIndex > 2,
    !,
    N is ColumnIndex - 3,
    get_square([Tail1, Tail2, Tail3], N, RowIndex, SubMatrix).

get_square([[X1, X2, X3 | _] | [[X4, X5, X6 | _] | [[X7, X8, X9 | _] | _]]], _, _, SubMatrix) :-
    Square = [X1, X2, X3, X4, X5, X6, X7, X8, X9],
    delete_vars(Square, SubMatrix).

% ===================================================================================================================

% validate(+Sudoku)
validate(Sudoku) :-
    length(Sudoku, 9),
    valid_numbers(Sudoku),
    validate_rows(Sudoku),
    validate_columns(Sudoku, 0),
    validate_squares(Sudoku, 0, 0),
    writeln("Sudoku is valid").

% valid_numbers(+Sudoku)
valid_numbers([]).
valid_numbers([Row | Tail]) :- valid_numbers_row(Row), valid_numbers(Tail).

% valid_numbers_row(+Row)
valid_numbers_row([]).
valid_numbers_row([H | Tail]) :- var(H), !, valid_numbers_row(Tail).
valid_numbers_row([H | Tail]) :- integer(H), H >= 1, H =< 9, valid_numbers_row(Tail).

% validate_rows(+Sudoku)
validate_rows([]).
validate_rows([H | Tail]) :- length(H, 9), delete_vars(H, Result), all_differs(Result), validate_rows(Tail).

% validate_columns(+Sudoku, +ColumnIndex)
validate_columns(_, 9) :- !.
validate_columns(Sudoku, ColumnIndex) :-
    nth_column(Sudoku, ColumnIndex, Result),
    all_differs(Result),
    N is ColumnIndex + 1,
    validate_columns(Sudoku, N).

% validate_squares(+Sudoku, +ColumnIndex, +RowIndex)
validate_squares(_, 9, 9) :- !.
validate_squares(Sudoku, 9, RowIndex) :- !, validate_squares(Sudoku, 0, RowIndex).
validate_squares(Sudoku, ColumnIndex, RowIndex) :-
    get_square(Sudoku, ColumnIndex, RowIndex, Result),
    all_differs(Result),
    CIndex is ColumnIndex + 3,
    RIndex is RowIndex + 1,
    validate_squares(Sudoku, CIndex, RIndex).

% all_differs(+List)
all_differs(List) :- all_differs(List, []).

all_differs([], _).
all_differs([H | Tail], Seen) :-
    not(member(H, Seen)),
    all_differs(Tail, [H | Seen]).

% ===================================================================================================================

sudoku_all :-
    sudoku_1,
    sudoku_2,
    sudoku_3,
    sudoku_4.

sudoku_1 :-
    Sudoku = [
        [_, 2, _,    4, 5, 6,    7, 8, 9],
        [4, 5, 7,    _, 8, _,    2, _, 6],
        [6, 8, 9,    2, 3, 7,    _, 4, _],

        [_, _, 5,    3, 6, 2,    9, 7, 4],
        [2, 7, 4,    _, 9, _,    6, 5, 3],
        [3, 9, 6,    5, 7, 4,    8, _, _],

        [_, 4, _,    6, 1, 8,    3, 9, 7],
        [7, _, 1,    _, 4, _,    5, 2, 8],
        [_, 3, 8,    7, _, 5,    _, 6, _]
    ],
    solve(Sudoku), !,
    Sudoku = [
        [1, 2, 3,    4, 5, 6,    7, 8, 9],
        [4, 5, 7,    1, 8, 9,    2, 3, 6],
        [6, 8, 9,    2, 3, 7,    1, 4, 5],

        [8, 1, 5,    3, 6, 2,    9, 7, 4],
        [2, 7, 4,    8, 9, 1,    6, 5, 3],
        [3, 9, 6,    5, 7, 4,    8, 1, 2],

        [5, 4, 2,    6, 1, 8,    3, 9, 7],
        [7, 6, 1,    9, 4, 3,    5, 2, 8],
        [9, 3, 8,    7, 2, 5,    4, 6, 1]
    ],
    write_ln("Test sudoku 1 --> Success!").

sudoku_2 :-
    Sudoku = [
        [_, _, 1,    4, _, 6,    8, _, _],
        [5, _, _,    2, _, 8,    _, _, 9],
        [9, 4, _,    5, _, 7,    _, 2, 1],

        [8, _, 4,    _, _, _,    9, _, 5],
        [_, _, _,    _, _, _,    _, _, _],
        [6, _, 2,    _, _, _,    3, _, 8],

        [2, 8, _,    7, _, 5,    _, 3, 6],
        [4, _, _,    6, _, 3,    _, _, 7],
        [_, _, 7,    1, _, 9,    5, _, _]
    ],
    solve(Sudoku), !,
    Sudoku = [
        [7, 2, 1,    4, 9, 6,    8, 5, 3],
        [5, 3, 6,    2, 1, 8,    4, 7, 9],
        [9, 4, 8,    5, 3, 7,    6, 2, 1],

        [8, 7, 4,    3, 6, 2,    9, 1, 5],
        [1, 9, 3,    8, 5, 4,    7, 6, 2],
        [6, 5, 2,    9, 7, 1,    3, 4, 8],

        [2, 8, 9,    7, 4, 5,    1, 3, 6],
        [4, 1, 5,    6, 8, 3,    2, 9, 7],
        [3, 6, 7,    1, 2, 9,    5, 8, 4]
    ],
    write_ln("Test sudoku 2 --> Success!").

sudoku_3 :-
    Sudoku = [
        [8, 3, 6,    _, _, _,    _, _, 1],
        [7, _, _,    1, _, _,    _, 3, _],
        [_, _, _,    _, _, _,    6, _, _],

        [2, _, _,    7, _, 3,    _, _, 4],
        [_, _, 5,    _, 4, _,    1, _, _],
        [9, _, _,    2, _, 5,    _, _, 8],

        [_, _, 7,    _, _, _,    _, _, _],
        [_, 9, _,    _, _, 8,    _, _, 3],
        [1, _, _,    _, _, _,    2, 9, 5]
    ],
    solve(Sudoku), !,
    Sudoku = [
        [8, 3, 6,    4, 9, 7,    5, 2, 1],
        [7, 5, 2,    1, 8, 6,    4, 3, 9],
        [4, 1, 9,    3, 5, 2,    6, 8, 7],

        [2, 6, 8,    7, 1, 3,    9, 5, 4],
        [3, 7, 5,    8, 4, 9,    1, 6, 2],
        [9, 4, 1,    2, 6, 5,    3, 7, 8],

        [5, 2, 7,    9, 3, 1,    8, 4, 6],
        [6, 9, 4,    5, 2, 8,    7, 1, 3],
        [1, 8, 3,    6, 7, 4,    2, 9, 5]
    ],
    write_ln("Test sudoku 3 --> Success!").

sudoku_4 :-
    Sudoku = [
        [_, 2, _,    _, 3, _,    _, _, _],
        [4, _, 1,    _, 2, _,    _, 6, _],
        [_, _, 5,    _, _, _,    4, 1, _],

        [_, _, _,    7, _, 4,    5, _, 6],
        [_, _, _,    _, _, _,    _, _, _],
        [8, _, 6,    2, _, 3,    _, _, _],

        [_, 3, _,    _, _, _,    9, _, _],
        [_, 5, _,    _, 9, _,    6, _, 3],
        [_, _, _,    _, 1, _,    _, 7, _]
    ],
    solve(Sudoku), !,
    Sudoku = [
        [6, 2, 9,    4, 3, 1,    7, 8, 5],
        [4, 7, 1,    5, 2, 8,    3, 6, 9],
        [3, 8, 5,    9, 7, 6,    4, 1, 2],

        [2, 1, 3,    7, 8, 4,    5, 9, 6],
        [5, 4, 7,    1, 6, 9,    2, 3, 8],
        [8, 9, 6,    2, 5, 3,    1, 4, 7],

        [7, 3, 8,    6, 4, 2,    9, 5, 1],
        [1, 5, 4,    8, 9, 7,    6, 2, 3],
        [9, 6, 2,    3, 1, 5,    8, 7, 4]
    ],
    write_ln("Test sudoku 4 --> Success!").

sudoku_5 :-
    Sudoku = [
        [_, _, _,    _, _, _,    _, _, _],
        [_, _, _,    _, _, _,    _, _, _],
        [_, _, _,    _, _, _,    _, _, _],

        [_, _, _,    _, _, _,    _, _, _],
        [_, _, _,    _, _, _,    _, _, _],
        [_, _, _,    _, _, _,    _, _, _],

        [_, _, _,    _, _, _,    _, _, _],
        [_, _, _,    _, _, _,    _, _, _],
        [_, _, _,    _, _, _,    _, _, _]
    ],
    solve(Sudoku).

% anti-brute-force sudoku
sudoku_6 :-
    Sudoku = [
        [4, _, _,    _, _, _,    8, _, 5],
        [_, 3, _,    _, _, _,    _, _, _],
        [_, _, _,    7, _, _,    _, _, _],

        [_, 2, _,    _, _, _,    _, 6, _],
        [_, _, _,    _, 8, _,    4, _, _],
        [_, _, _,    _, 1, _,    _, _, _],

        [_, _, _,    6, _, 3,    _, 7, _],
        [5, _, _,    2, _, _,    _, _, _],
        [1, _, 4,    _, _, _,    _, _, _]
    ],
    solve(Sudoku).

% ===================================================================================================================

tests :-
    test_remove,
    test_delete_vars,
    test_all_differs,
    test_valid_numbers_row,
    test_solve_row,
    test_get_column_row_square, !.

test_remove :-
    % remove(+RemoveFrom, +ElementsToRemove, -Result)
    remove([1, 2, 3, 4, 5], [1, 4], [2, 3, 5]),
    remove([], [1, 3, 5], []),
    remove([1, 1, 1, 2], [1, 2], []),
    remove([1, 2], [], [1, 2]),
    writeln("Tests for 'remove' passed successfully.").

test_delete_vars :-
    % delete_vars(+List, -Result)
    delete_vars([1, 2, 3, 4], [1, 2, 3, 4]),
    delete_vars([1, 3, _, 7, _], [1, 3, 7]),
    delete_vars([], []),
    delete_vars([_, _], []),
    writeln("Tests for 'delete_vars' passed successfully.").

test_all_differs :-
    % all_differs(+List)
    all_differs([]),
    all_differs([1, 2, 3]),
    not(all_differs([1, 1])),
    not(all_differs([1, 2, 1, 3])),
    writeln("Tests for 'all_differs' passed successfully.").

test_valid_numbers_row :-
    % valid_numbers_row(+Row)
    valid_numbers_row([1, 2, 3, _, 5]),
    valid_numbers_row([_, _, _]),
    not(valid_numbers_row([1, 2, 2.5])),
    not(valid_numbers_row([1, _, 5, 10, 7])),
    not(valid_numbers_row([1, 2, _, 0])),
    writeln("Tests for 'valid_numbers_row' passed successfully.").

test_solve_row :-
    Sudoku = [
        [_, 2, _,    6, _, 4,    _, 8, 7],
        [7, 8, 1,    2, 5, 3,    6, 9, 4],
        [9, 4, 6,    7, 1, 8,    2, 3, 5],

        [2, 3, 4,    5, 7, 6,    9, 1, 8],
        [6, 9, 8,    4, 2, 1,    5, 7, 3],
        [1, 7, 5,    3, 8, 9,    4, 6, 2],

        [8, 6, 2,    1, 4, 7,    3, 5, 9],
        [3, 5, 7,    9, 6, 2,    8, 4, 1],
        [4, 1, 9,    8, 3, 5,    7, 2, 6]
    ],
    Sudoku = [Row | _],
    solve_row(Row, Sudoku, 0, 0),
    Row = [5, 2, 3, 6, 9, 4, 1, 8, 7],
    writeln("Tests for 'solve_row' passed successfully.").

test_get_column_row_square :-
    Sudoku = [
        [5, 2, 3,    6, 9, 4,    1, 8, 7],
        [7, 8, 1,    2, _, 3,    6, 9, 4],
        [9, 4, 6,    7, 1, 8,    2, 3, 5],

        [2, 3, 4,    5, 7, 6,    9, 1, 8],
        [6, 9, _,    4, _, 1,    5, 7, 3],
        [1, _, 5,    3, 8, 9,    4, 6, 2],

        [8, 6, 2,    1, 4, 7,    3, 5, 9],
        [3, 5, 7,    9, 6, 2,    8, 4, 1],
        [4, 1, 9,    8, 3, 5,    7, 2, 6]
    ],

    % nth_column(+Matrix, +Index, -Column)
    nth_column(Sudoku, 0, [5, 7, 9, 2, 6, 1, 8, 3, 4]),
    nth_column(Sudoku, 7, [8, 9, 3, 1, 7, 6, 5, 4, 2]),
    nth_column(Sudoku, 4, [9, 1, 7, 8, 4, 6, 3]),
    writeln("Tests for 'nth_column' passed successfully."),

    % nth_row(+Matrix, +RowIndex, -Result)
    nth_row(Sudoku, 0, [5, 2, 3, 6, 9, 4, 1, 8, 7]),
    nth_row(Sudoku, 7, [3, 5, 7, 9, 6, 2, 8, 4, 1]),
    nth_row(Sudoku, 4, [6, 9, 4, 1, 5, 7, 3]),
    writeln("Tests for 'nth_row' passed successfully."),

    % get_square(+Matrix, +ColumnIndex, +RowIndex, -SubMatrix)
    get_square(Sudoku, 2, 0, [5, 2, 3, 7, 8, 1, 9, 4, 6]),
    get_square(Sudoku, 7, 7, [3, 5, 9, 8, 4, 1, 7, 2, 6]),
    get_square(Sudoku, 1, 5, [2, 3, 4, 6, 9, 1, 5]),
    writeln("Tests for 'get_square' passed successfully.").
