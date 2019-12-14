%{
    #include <stdio.h>
    extern int yylex();
    void yyerror(const char *message);
%}
%union {
    int     intVal;
    struct matrix {
        int row, col;
    } mat;
}
%type <intVal> NUMBER 
%type <mat> expr
%type <mat> matrix
%left <intVal> '+' '-' '*'
%token NUMBER TRANS 

%% 
start       : expr '\n' { printf("Accepted\n"); }
            ;
expr        : expr '+' expr {
                if($1.col == $3.col && $1.row == $3.row)
                    $$ = $1;
                else {
                    printf("Semantic error on col %d\n", $2);
                    YYABORT;
                }
            }
            | expr '-' expr {
                if($1.col == $3.col && $1.row == $3.row)
                    $$ = $1;
                else {
                    printf("Semantic error on col %d\n", $2);
                    YYABORT;
                }
            }
            | expr '*' expr {
                if($1.row == $3.col){
                    $$.col = $1.col;
                    $$.row = $3.row;
                }
                else {
                    printf("Semantic error on col %d\n", $2);
                    YYABORT;
                }
            }
            | '(' expr ')' {
                $$ = $2;
            }
            | expr TRANS {
                $$.col = $1.row;
                $$.row = $1.col;
            }
            | matrix 
            ;
matrix      : '[' NUMBER ',' NUMBER ']' {
                $$.col = $2;
                $$.row = $4;
            }
%%

void yyerror(const char* message) {
    printf("Invaild format\n");
};

int main() {
    yyparse();
    return 0;
}