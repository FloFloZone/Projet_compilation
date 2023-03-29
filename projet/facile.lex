%{
#include <assert.h>
#include <glib.h>
#include "facile.y.h"

/* avant modifications */

// #define TOK_IF           258
// #define TOK_THEN         259
// #define TOK_ELSE         260
// #define TOK_ELSE_IF      261
// #define TOK_END          262
// #define TOK_ENDIF        263

// #define TOK_WHILE        264
// #define TOK_ENDWHILE     265

// #define TOK_CONTINUE     266
// #define TOK_BREAK        267

// #define TOK_SEMI_COLON   268
// #define TOK_AFFECTATION  269

// #define TOK_PRINT        270
// #define TOK_READ         271

// #define TOK_IDENTIFIER   272
// #define TOK_NUMBER       273

// #define TOK_LEFT_PARENT  274
// #define TOK_RIGHT_PARENT 275

// #define TOK_ADD          276
// #define TOK_SUB          277
// #define TOK_DIV          278
// #define TOK_MUL          279
// #define TOK_MOD          280

// #define TOK_TRUE         281
// #define TOK_FALSE        282

// #define TOK_AND          283
// #define TOK_OR           284
// #define TOK_NOT          285
// #define TOK_SUP          286
// #define TOK_INF          287
// #define TOK_EQUALS       288
// #define TOK_SUPEQUAL     289
// #define TOK_INFEQUAL     290
// #define TOK_NOTEQUAL      291

// #define TOK_DO           292

%}

%option yylineno

%%
if { assert(printf("'if' Trouvé\n")); return TOK_IF; }

then { assert(printf("'then' Trouvé\n")); return TOK_THEN; }

else { assert(printf("'else' Trouvé\n")); return TOK_ELSE; }

elseif { assert(printf("'elseif' Trouvé\n")); return TOK_ELSE_IF; }

end { assert(printf("'end' Trouvé\n")); return TOK_END; }

endif { assert(printf("'endif' Trouvé\n")); return TOK_ENDIF; }

while { assert(printf("'while' Trouvé\n")); return TOK_WHILE;}

endwhile { assert(printf("'endwhile' Trouvé\n")); return TOK_ENDWHILE; }

do { assert(printf("'do' Trouvé\n")); return TOK_DO; }

continue { assert(printf("'continue' Trouvé\n")); return TOK_CONTINUE; }

break { assert(printf("'break' Trouvé\n")); return TOK_BREAK; }

";" { assert(printf("'semicolon' Trouvé\n")); return TOK_SEMI_COLON; }

":=" { assert(printf("':=' Trouvé\n")); return TOK_AFFECTATION; }

print { assert(printf("'print' Trouvé\n")); return TOK_PRINT; }

read { assert(printf("'read' Trouvé\n")); return TOK_READ; }

true { assert(printf("'true' Trouvé\n")); return TOK_TRUE; }

false { assert(printf("'false' Trouvé\n")); return TOK_FALSE; }

and { assert(printf("'and' Trouvé\n")); return TOK_AND; }

or { assert(printf("'or' Trouvé\n")); return TOK_OR; }

not { assert(printf("'not' Trouvé\n")); return TOK_NOT; }

"(" { assert(printf("'(' Trouvé\n")); return TOK_LEFT_PARENT; }

")" { assert(printf("')' Trouvé\n")); return TOK_RIGHT_PARENT; }

"+" { assert(printf("'+' Trouvé\n")); return TOK_ADD; }

"-" { assert(printf("'-' Trouvé\n")); return TOK_SUB; }

"/" { assert(printf("'/' Trouvé\n")); return TOK_DIV; }

"*" { assert(printf("'*' Trouvé\n")); return TOK_MUL; }

"%" { assert(printf("'%%' Trouvé\n")); return TOK_MOD; }

">=" { assert(printf("'>=' Trouvé\n")); return TOK_SUPEQUAL; }

"<=" { assert(printf("'<=' Trouvé\n")); return TOK_INFEQUAL; }

">" { assert(printf("'>' Trouvé\n")); return TOK_SUP; }

"<" { assert(printf("'<' Trouvé\n")); return TOK_INF; }

"=" { assert(printf("'=' Trouvé\n")); return TOK_EQUALS; }

# { assert(printf("'#' Trouvé\n")); return TOK_NOTEQUAL; }

[a-zA-Z][a-zA-Z0-9_]* { assert(printf("'identificateur' Trouvé\n")); yylval.string = yytext; return TOK_IDENTIFIER; }

[1-9]*[0-9] { assert(printf("'number' Trouvé\n")); sscanf(yytext, "%lu", &yylval.number); return TOK_NUMBER; }

[ \t\n] ;

. { return yytext[0]; }

%%