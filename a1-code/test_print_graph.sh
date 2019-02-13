#!/bin/bash

GENERATE=1

VALGRIND="valgrind --leak-check=full --show-leak-kinds=all"
EXPECT=test-data/expect.txt                 # name for expected output file
ACTUAL=test-data/actual.txt                 # name for actual output file
VALGOUT=test-data/valgrind.txt              # name for valgrind output file
DIFFOUT=test-data/test.diff                 # name for diff output file

# Generate the expected output file
cat > $EXPECT <<EOF
DEMO DATA 1
===========
length: 22
min: 0
max: 20
range: 20
max_height: 10
units_per_height: 2.00
     +----+----+----+----+-
 20 |                    X 
 18 |                   XX 
 16 |                  XXX 
 14 |                 XXXX 
 12 |                XXXXX 
 10 |          X    XXXXXXX
  8 |        XXX   XXXXXXXX
  6 |      XXXXX  XXXXXXXXX
  4 |    XXXXXXX XXXXXXXXXX
  2 |  XXXXXXXXXXXXXXXXXXXX
  0 |XXXXXXXXXXXXXXXXXXXXXX
     +----+----+----+----+-
     0    5    10   15   20   

DEMO DATA 2
===========
length: 22
min: 0
max: 20
range: 20
max_height: 20
units_per_height: 1.00
     +----+----+----+----+-
 20 |                    X 
 19 |                    X 
 18 |                   XX 
 17 |                   XX 
 16 |                  XXX 
 15 |                  XXX 
 14 |                 XXXX 
 13 |                 XXXX 
 12 |                XXXXX 
 11 |                XXXXX 
 10 |          X    XXXXXXX
  9 |         XX    XXXXXXX
  8 |        XXX   XXXXXXXX
  7 |       XXXX   XXXXXXXX
  6 |      XXXXX  XXXXXXXXX
  5 |     XXXXXX  XXXXXXXXX
  4 |    XXXXXXX XXXXXXXXXX
  3 |   XXXXXXXX XXXXXXXXXX
  2 |  XXXXXXXXXXXXXXXXXXXX
  1 | XXXXXXXXXXXXXXXXXXXXX
  0 |XXXXXXXXXXXXXXXXXXXXXX
     +----+----+----+----+-
     0    5    10   15   20   

DEMO DATA 3
===========
length: 50
min: 13
max: 996
range: 983
max_height: 10
units_per_height: 98.30
     +----+----+----+----+----+----+----+----+----+----
996 |                X                                 
897 |       X        X X            X                  
799 |  X    X X   X  X X    X       X                X 
701 |  XX   X X   X  XXX    X      XX   XXX    X   X XX
602 |  XX   X X  XX  XXX X  X      XX  XXXX    XX  X XX
504 |  XX   XXX  XX  XXX XX X      XXX XXXX XX XX  X XX
406 |  XX X XXX XXXX XXX XX X  XXX XXX XXXXXXXXXX  X XX
307 | XXX X XXX XXXXXXXXXXX X XXXX XXXXXXXXXXXXXXX X XX
209 | XXX XXXXXXXXXXXXXXXXX XXXXXX XXXXXXXXXXXXXXXXX XX
111 | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 13 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
     +----+----+----+----+----+----+----+----+----+----
     0    5    10   15   20   25   30   35   40   45   

DEMO DATA 4
===========
length: 50
min: 13
max: 996
range: 983
max_height: 18
units_per_height: 54.61
     +----+----+----+----+----+----+----+----+----+----
996 |                X                                 
941 |                X              X                  
886 |       X        X X            X                  
832 |       X X      X X            X                X 
777 |  X    X X   X  XXX    X       X   XXX          XX
722 |  XX   X X   X  XXX    X       X   XXX          XX
668 |  XX   X X   X  XXX    X      XX  XXXX    X   X XX
613 |  XX   X X  XX  XXX    X      XX  XXXX    XX  X XX
559 |  XX   XXX  XX  XXX XX X      XX  XXXX  X XX  X XX
504 |  XX   XXX  XX  XXX XX X      XXX XXXX XX XX  X XX
449 |  XX X XXX XXXX XXX XX X   X  XXX XXXX XX XX  X XX
395 | XXX X XXX XXXX XXX XX X  XXX XXX XXXXXXXXXX  X XX
340 | XXX X XXX XXXXXXXXXXX X  XXX XXXXXXXXXXXXXXX X XX
286 | XXX X XXX XXXXXXXXXXX X XXXX XXXXXXXXXXXXXXX X XX
231 | XXX X XXXXXXXXXXXXXXX XXXXXX XXXXXXXXXXXXXXXXX XX
176 | XXX XXXXXXXXXXXXXXXXX XXXXXX XXXXXXXXXXXXXXXXXXXX
122 | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 67 | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 13 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
     +----+----+----+----+----+----+----+----+----+----
     0    5    10   15   20   25   30   35   40   45   
EOF

# run the student code
./print_graph_demo >& $ACTUAL

# check for normal output
# -b ignore whitespace
# -B ignore blank lines
# -y do side-by-side comparison
if ! diff -bBy $EXPECT $ACTUAL > $DIFFOUT
then
    printf "FAIL: Output Incorrect\n"
    minor_sep
    printf "INPUT:\n%s\n" "${input[i]}"
    printf "OUTPUT: EXPECT   vs   ACTUAL\n"
    cat $DIFFOUT
    if [ "$generate" == "1" ]; then
        printf "FULL ACTUAL\n"
        cat $ACTUAL
    fi
else
    printf "Output OK\n"
fi

$VALGRIND ./print_graph_demo >& $VALGOUT

# Check various outputs from valgrind
if ! grep -q 'ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)' $VALGOUT ||
   ! grep -q 'in use at exit: 0 bytes in 0 blocks'  $VALGOUT ||
     grep -q 'definitely lost: 0 bytes in 0 blocks' $VALGOUT;
then
    printf "FAIL: Valgrind detected problems\n"
    printf "================================\n"
    cat $VALGOUT
    printf "================================\n"
else
    printf "Valgrind OK\n"
fi

