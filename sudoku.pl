/* Main rule of program */
sudoku(Board) :-
    /* Ensure there are 9 rows */
    checkLength(Board),

    /* Ensure each row is of length 9. */
    maplist(checkLength, Board),

    /* Make sure all numbers are different in 
    each row and col. */
    within_domain(Board, 9),
    maplist(fd_all_different, Board),
    transpose(Board, BoardT),
    maplist(fd_all_different, BoardT),

    /* Make sure each soduku cell is valid. */
    Board = [A,B,C,D,E,F,G,H,I],
    validateCell(A,B,C),
    validateCell(D,E,F),
    validateCell(G,H,I),

    maplist(fd_labeling, Board).

/* Check to make sure each s*/
validateCell([],[],[]).
validateCell([Row1a, Row1b, Row1c | Row1Rest], 
             [Row2a, Row2b, Row2c | Row2Rest],
             [Row3a, Row3b, Row3c | Row3Rest]) :-
    fd_all_different([Row1a, Row1b, Row1c,
                      Row2a, Row2b, Row2c,
                      Row3a, Row3b, Row3c]),
    validateCell(Row1Rest, Row2Rest, Row3Rest).


/* Checks to see if length of row is 9 elements. */
checkLength(Row) :-
    length(Row, 9).

/* Implementation of transpose from:
        https://stackoverflow.com/questions/4280986/how-to-transpose-a-matrix-in-prolog */
transpose([], []).
transpose([F|Fs], Ts) :-
    transpose(F, [F|Fs], Ts).
transpose([], _, []).
transpose([_|Rs], Ms, [Ts|Tss]) :-
        lists_firsts_rests(Ms, Ts, Ms1),
        transpose(Rs, Ms1, Tss).
lists_firsts_rests([], [], []).
lists_firsts_rests([[F|Os]|Rest], [F|Fs], [Os|Oss]) :-
        lists_firsts_rests(Rest, Fs, Oss).


/* From https://github.com/CS131-TA-team/UCLA_CS131_CodeHelp */
within_domain([], _).
within_domain([HD | TL], N) :-
    % http://www.gprolog.org/manual/html_node/gprolog057.html fd_domain(Vars, Lower, Upper)
    fd_domain(HD, 1, N),
    within_domain(TL, N).

/* Formats output to look nice on GNU Prolog Console. */
sudokuSolver(Board) :-
    sudoku(Board), 
    maplist(fd_labeling, Board), 
    maplist(portray_clause, Board).