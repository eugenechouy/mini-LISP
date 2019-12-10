%{
    #include <stdio.h>
    int yylex();
    void yyerror(const char *message);
    double ans = 0;
%}
%union {
    float   floatVal;
    int     intVal;
}
%type <floatVal> expression
%type <floatVal> prob
%token LEFT_P RIGHT_P NUMBER

%% 
input       : input expression { 
                ans = $2; printf("%.2f\n", ans); 
            }
            | input LEFT_P RIGHT_P { } 
            | { }
            ;
expression  : NUMBER 
            | LEFT_P prob expression expression RIGHT_P { 
                $$ = $2 * ($3 + $4) + (1.0f - $2) * ($3 - $4);
            }
            ;
prob        : NUMBER
            ;
%%

void yyerror(const char* message) {
    printf("Invaild format\n");
};

int main() {
    yyparse();
    return 0;
}