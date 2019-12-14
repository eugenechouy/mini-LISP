%{
    #include <stdio.h>
    #include <stdbool.h>
    extern int yylex();
    void yyerror(const char *message);
    void push(int *stk, int num);
    int pop(int *stk);
    int stk[1000];
    int top = 0;
    int tmp = 0;
    bool stack_error = false;
%}
%union {
    int     intVal;
}
%type <intVal> NUMBER
%token NUMBER ADD SUB MUL MOD INC DEC LOAD

%% 
start       : start line { }
            | line { }
            ;
line        : ADD {
                if(top < 2){
                    stack_error = true;
                    YYABORT;
                }
                tmp = pop(stk) + pop(stk);
                push(stk, tmp);
            }
            | SUB {
                if(top < 2){
                    stack_error = true;
                    YYABORT;
                }
                tmp = pop(stk) - pop(stk);
                push(stk, tmp);
            }
            | MUL {
                if(top < 2){
                    stack_error = true;
                    YYABORT;
                }
                tmp = pop(stk) * pop(stk);
                push(stk, tmp);
            }
            | MOD {
                if(top < 2){
                    stack_error = true;
                    YYABORT;
                }
                tmp = pop(stk) % pop(stk);
                push(stk, tmp);
            }
            | INC {
                if(top < 1){
                    stack_error = true;
                    YYABORT;
                }
                tmp = pop(stk)+1;
                push(stk, tmp);
            }
            | DEC {
                if(top < 1){
                    stack_error = true;
                    YYABORT;
                }
                tmp = pop(stk)-1;
                push(stk, tmp);
            }
            | LOAD NUMBER {
                push(stk, $2);
            }
            ;
%%

void yyerror(const char* message) {
    printf("Invaild format\n");
};

void push(int *stk, int num) {
    stk[top++] = num;
}

int pop(int *stk){
    return stk[--top];
}

int main() {
    yyparse();
    tmp = pop(stk);
    if(top || stack_error) 
        printf("Invalid format\n");
    else
        printf("%d\n", tmp);
    return 0;
}