%{
#include <stdlib.h>
#include <stdio.h>
#include <glib.h>
#include <ctype.h>
#include <assert.h>
#include <stdarg.h>

extern int yylex(void);
extern int yyerror(const char *msg);

char* module_name = NULL;
FILE *stream = NULL;
GHashTable *table = NULL;
GQueue *label_queue = NULL;
GQueue *end_label = NULL;

int var_count = 0;

void begin_code();
void produce_code(GNode* node);
void produce_code_inverse(GNode* node);
void produce_code_litteral(GNode* node);
void end_code();
int nb_il(GNode *node);
%}

%union {
    gulong number;
    gchar *string;
    GNode * node;
}

%define parse.error verbose

%token TOK_IF                   "if"
%token TOK_THEN                 "then"
%token TOK_ELSE                 "else"
%token TOK_ELSE_IF              "elseif"
%token TOK_END                  "end"
%token TOK_ENDIF                "endif"

%token TOK_WHILE                "while"
%token TOK_ENDWHILE             "endwhile"
%token TOK_DO                   "do"

%token TOK_CONTINUE             "continue"
%token TOK_BREAK                "break"

%token TOK_SEMI_COLON           ";"
%token TOK_AFFECTATION          ":="

%token TOK_PRINT                "print"
%token TOK_READ                 "read"

%token<string> TOK_IDENTIFIER   "identifier"
%token<number> TOK_NUMBER       "number"

%token TOK_LEFT_PARENT          "("
%token TOK_RIGHT_PARENT         ")"

%left TOK_ADD                   "+"
%left TOK_SUB                   "-"
%left TOK_DIV                   "/"
%left TOK_MUL                   "*"
%left TOK_MOD                   "%"
%token TOK_TRUE                 "true"
%token TOK_FALSE                "false"

%left TOK_AND                   "and"
%left TOK_OR                    "or"
%left TOK_NOT                   "not"
%left TOK_SUP                   ">"
%left TOK_INF                   "<"
%left TOK_EQUALS                "="
%left TOK_SUPEQUAL              ">="
%left TOK_INFEQUAL              "<="
%left TOK_NOTEQUAL               "#"

%type<node>   code

%type<node>   instruction

%type<node>   identifier
%type<node>   number

%type<node>   read
%type<node>   print
%type<node>   affectation
%type<node>   test
%type<node>   boucle
%type<node>   expression
%type<node>   boolean

%type<node>   code_while

%%

program: code {
    begin_code();
    produce_code($1);
    end_code();
    g_node_destroy($1);
};  

code: code instruction 
    {
        $$ = g_node_new("code");
        g_node_append($$, $1);
        g_node_append($$, $2);
    } 
    | 
    {
        $$ = g_node_new("");
};

instruction: read | print |  affectation | test | boucle;


read: TOK_READ identifier TOK_SEMI_COLON {
    $$ = g_node_new("read");
    g_node_append($$, $2);
};

print: TOK_PRINT expression TOK_SEMI_COLON {
    $$ = g_node_new("print");
    g_node_append($$, $2);
};

affectation:
    identifier TOK_AFFECTATION expression TOK_SEMI_COLON {
        $$ = g_node_new("affectation");
        var_count++;
        g_node_append($$, $1);
        g_node_append($$, $3);
};

test:
    TOK_IF boolean TOK_THEN code TOK_END {
        $$ = g_node_new("if");
        g_node_append($$, $2);
        g_node_append($$, $4);
    }
    |
    TOK_IF boolean TOK_THEN code TOK_ENDIF {
        $$ = g_node_new("if");
        g_node_append($$, $2);
        g_node_append($$, $4);
    }
    |
    TOK_ELSE_IF boolean TOK_THEN code{
        $$ = g_node_new("elseif");
        g_node_append($$, $2);
        g_node_append($$, $4);
    }
    |
    TOK_ELSE code{
        $$ = g_node_new("else");
        g_node_append($$, $2);
};

boucle:
    TOK_WHILE boolean TOK_DO code_while TOK_END {
        $$ = g_node_new("while");
        g_node_append($$, $2);
        g_node_append($$, $4);
    }
    |
    TOK_WHILE boolean TOK_DO code_while TOK_ENDWHILE {
        $$ = g_node_new("while");
        g_node_append($$, $2);
        g_node_append($$, $4);
};

code_while:
    instruction code_while{
        $$ = g_node_new("code_wile");
        g_node_append($$, $1);
    }
    |
    TOK_CONTINUE {
        $$ = g_node_new("continue");
    }
    |
    TOK_BREAK {
        $$ = g_node_new("break");
    };

expression:
    identifier
    |
    number
    |
    boolean
    |
    expression TOK_ADD expression {
        $$ = g_node_new("add");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    expression TOK_SUB expression {
        $$ = g_node_new("sub");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    expression TOK_MUL expression {
        $$ = g_node_new("mul");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    expression TOK_DIV expression {
        $$ = g_node_new("div");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    TOK_LEFT_PARENT expression TOK_RIGHT_PARENT{
        $$ = g_node_new("parenthesis");
        g_node_append($$, $2);
    }
    |
    expression TOK_MOD expression {
        $$ = g_node_new("mod");
        g_node_append($$, $1);
        g_node_append($$, $3);
    };

boolean: 
    TOK_TRUE {
        $$ = g_node_new("true");
    }
    |
    TOK_FALSE {
        $$ = g_node_new("false");
    }
    |
    expression TOK_INFEQUAL expression {
        $$ = g_node_new("INFEQUAL");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    expression TOK_SUPEQUAL expression {
        $$ = g_node_new("SUPEQUAL");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    expression TOK_SUP expression {
        $$ = g_node_new("SUP");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    expression TOK_INF expression {
        $$ = g_node_new("INF");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    expression TOK_EQUALS expression {
        $$ = g_node_new("EQUAL");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    expression TOK_NOTEQUAL expression {
        $$ = g_node_new("EQUAL");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    TOK_NOT expression {
        $$ = g_node_new("NOT");
        g_node_append($$, $2);
    }
    |
    boolean TOK_AND boolean {
        $$ = g_node_new("AND");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    boolean TOK_OR boolean {
        $$ = g_node_new("OR");
        g_node_append($$, $1);
        g_node_append($$, $3);
    }
    |
    TOK_LEFT_PARENT boolean TOK_RIGHT_PARENT {
        $$ = g_node_new("parenthese");
        g_node_append($$, $2);
    };

identifier:
    TOK_IDENTIFIER {
        $$ = g_node_new("identifier");
        gulong value = (gulong) g_hash_table_lookup(table, $1);
        if (!value) {
            value = g_hash_table_size(table) + 1;
            g_hash_table_insert(table, strdup($1), (gpointer) value);
        }
        g_node_append_data($$, (gpointer)value);
};

number:
    TOK_NUMBER 
    {
        $$ = g_node_new("number");
        g_node_append_data($$, (gpointer)$1);
};


%%



void begin_code() {
    // start
    fprintf(stream, ".assembly %s {}\n", module_name);
    fprintf(stream, ".assembly extern mscorlib {}\n");
    fprintf(stream,
    "// method line 1\n.method static void Main ()\n\{\n\t.entrypoint\n");

    // debut de main
    fprintf(stream, "\t.maxstack 10\n");
    if (var_count > 0) {
        fprintf(stream, "\t.locals init (int32");
        for (int i=1; i < var_count; i++) {
            fprintf(stream, ", int32");
        }
        fprintf(stream, ")\n");
    }
}


// if construct val
int label_count = 0;
int end_while_label = 0;
int boolean_while_label = 0;

void produce_code(GNode* node) {
    if (node->data == "code") {
        produce_code(g_node_nth_child(node, 0));
        produce_code(g_node_nth_child(node, 1));

    } else if (node->data == "affectation") {
        // declaration d'une variable
        produce_code(g_node_nth_child(node, 1));
        fprintf(stream,"\tstloc\t%ld\n",(long) g_node_nth_child(g_node_nth_child(node, 0), 0)->data - 1);
    } else if (node->data == "add") {
        // ajout de 2 expression
        produce_code(g_node_nth_child(node, 0));
        produce_code(g_node_nth_child(node, 1));
        fprintf(stream, "\add\n");

    } else if (node->data == "sub") {
        // soustraction de 2 expression
        produce_code(g_node_nth_child(node, 0));
        produce_code(g_node_nth_child(node, 1));
        fprintf(stream, "\tsub\n");
    
    } else if (node->data == "mul") {
        // multiplication de 2 expression
        produce_code(g_node_nth_child(node, 0));
        produce_code(g_node_nth_child(node, 1));
        fprintf(stream, "\tmul\n");

    } else if (node->data == "div") {
        // division de 2 expression
        produce_code(g_node_nth_child(node, 0));
        produce_code(g_node_nth_child(node, 1));
        fprintf(stream, "\tdiv\n");

    } else if (node->data == "mod") {
        // modulo de 2 expression
        produce_code(g_node_nth_child(node, 0));
        produce_code(g_node_nth_child(node, 1));
        fprintf(stream, "\trem\n");
    } else if (node->data == "number") {
        // c'est un nombre
        fprintf(stream,"\tldc.i4\t%ld\n", (long) g_node_nth_child(node, 0)->data);
    } else if (node->data == "identifier") {
        // c'est un identifier
        assert(fprintf(
            stream,
            "\t// load var %ld in stack\n",
            (long) g_node_nth_child(node, 0)->data - 1));
        fprintf(
            stream,
            "\tldloc\t%ld\n",
            (long) g_node_nth_child(node, 0)->data - 1
        );
    } else if (node->data == "print") {
        // print d'une expression
        produce_code(g_node_nth_child(node, 0));
        fprintf(stream, "\tcall void class [mscorlib] System.Console::WriteLine(int32)\n");

    } else if (node->data == "read") {
        // scan d'une expression
        fprintf(stream, "\tcall string class [mscorlib]System.Console::ReadLine()\n");
        fprintf(stream, "\tcall int32 int32::Parse(string)\n");
        fprintf(stream, "\tstloc\t%ld\n", (long) g_node_nth_child(g_node_nth_child(node, 0), 0)->data - 1);
    } else if (node->data == "if") {
        // utilise 2 label
        label_count++;
        g_queue_push_head(label_queue, GINT_TO_POINTER(label_count));
        label_count++;
        g_queue_push_head(label_queue, GINT_TO_POINTER(label_count));
        
        int tmp_il = label_count + nb_il(node);
        g_queue_push_head(end_label, GINT_TO_POINTER(tmp_il));
        // cas ou il y a un else
        int temp_if = label_count;

        // boolean
        produce_code(g_node_nth_child(node, 0));
        
        // code interne
        // label de debut de bloc
        int end = GPOINTER_TO_INT(g_queue_pop_head(label_queue));
        fprintf(stream, "IL_%x:", GPOINTER_TO_INT(g_queue_pop_head(label_queue)));
        g_queue_push_head(label_queue, GINT_TO_POINTER(end));
        produce_code(g_node_nth_child(node, 1));

        // fin du bloc
        fprintf(stream, "IL_%x:", GPOINTER_TO_INT(g_queue_pop_head(label_queue)));
        fprintf(stream, "IL_%x:", GPOINTER_TO_INT(g_queue_pop_head(end_label)));

        // eviter tout conflit on augmente de 1
        label_count = tmp_il;

    } else if (node->data == "elseif") {
        // fin du parent saute fin e on rajoute le label de elseif
        fprintf(stream, "\tbr IL_%x\n", GPOINTER_TO_INT(g_queue_peek_head(end_label)));
        fprintf(stream, "IL_%x:", GPOINTER_TO_INT(g_queue_pop_head(label_queue)));

        // label
        label_count++;
        g_queue_push_head(label_queue, GINT_TO_POINTER(label_count));
        label_count++;
        g_queue_push_head(label_queue, GINT_TO_POINTER(label_count));

        int temp_if = label_count;

        // boolean
        produce_code(g_node_nth_child(node, 0));

        // code interne
        // label de debut de bloc
        int end = GPOINTER_TO_INT(g_queue_pop_head(label_queue));
        fprintf(stream, "IL_%x:", GPOINTER_TO_INT(g_queue_pop_head(label_queue)));
        g_queue_push_head(label_queue, GINT_TO_POINTER(end));
        produce_code(g_node_nth_child(node, 1));

        // fin du elsif
        if (label_count == temp_if) {
            fprintf(stream, "IL_%x:", GPOINTER_TO_INT(g_queue_pop_head(label_queue)));
        }

    } else if (node->data == "else") {
        fprintf(stream, "\tbr IL_%x\n", GPOINTER_TO_INT(g_queue_peek_head(end_label)));
        fprintf(stream, "IL_%x:", GPOINTER_TO_INT(g_queue_pop_head(label_queue)));

        // else
        produce_code(g_node_nth_child(node, 0));
        label_count++;

    } else if (node->data == "while") {
        label_count++;
        g_queue_push_head(label_queue, GINT_TO_POINTER(label_count));
        label_count++;
        end_while_label = label_count;
        g_queue_push_head(label_queue, GINT_TO_POINTER(label_count));

        int tmp_il = label_count + nb_il(node);
        boolean_while_label = tmp_il;
        g_queue_push_head(end_label, GINT_TO_POINTER(tmp_il));

        fprintf(stream, "IL_%x:", GPOINTER_TO_INT(g_queue_peek_head(end_label)));
        produce_code(g_node_nth_child(node, 0));
        // label start block
        int tmp = GPOINTER_TO_INT(g_queue_pop_head(label_queue));
        fprintf(stream, "IL_%x:", GPOINTER_TO_INT(g_queue_peek_head(label_queue)));
        g_queue_push_head(label_queue, GINT_TO_POINTER(tmp));
        // block
        produce_code(g_node_nth_child(node, 1));
        fprintf(stream, "\tbr IL_%x\n", GPOINTER_TO_INT(g_queue_pop_head(end_label)));
        fprintf(stream, "IL_%x:", GPOINTER_TO_INT(g_queue_pop_head(label_queue)));

        label_count = tmp_il;
    } else if (node->data == "break") {
        fprintf(stream, "\tbr IL_%x\n", end_while_label);
    } else if (node->data == "continue") {
        fprintf(stream, "\tbr IL_%x\n", boolean_while_label);
    } else if (node->data == "AND") {
        produce_code_inverse(g_node_nth_child(node, 0));
        produce_code(g_node_nth_child(node, 1));
    } else if (node->data == "OR") {
        produce_code_litteral(g_node_nth_child(node, 0));
        produce_code(g_node_nth_child(node, 1));
    } else if (node->data == "SUP") {
        produce_code_inverse(node);
    } else if (node->data == "INF") {
        produce_code_inverse(node);
    } else if (node->data == "INFEQUAL") {
        produce_code_inverse(node);
    } else if (node->data == "SUPEQUAL") {
        produce_code_inverse(node);
    } else if (node->data == "EQUAL") {
        produce_code_inverse(node);
    } else if (node->data == "NOT") {
        produce_code_inverse(node);
    } else if (node->data == "NULL") {
        // rien
    }
}

// compte le nombre de label dans un if
int nb_il(GNode *node) {
    int results = 0;
    if (node->data == "if" || node->data == "elseif" || node->data == "while")
        results = 3;
    for (int i = 0; i < g_node_n_children(node); i++)
        results += nb_il(g_node_nth_child(node, i));
    return results;
}

// construit les booleans boolean oppose a celle ecrite
void produce_code_inverse(GNode* node) {
    int il = GPOINTER_TO_INT(g_queue_peek_head(label_queue));
    // expression 1
    produce_code(g_node_nth_child(node, 0));
    // expression 2
    produce_code(g_node_nth_child(node, 1));
    if (node->data == "SUP") {
        // compare l'inverse
        fprintf(stream, "\tble IL_%x\n", il);

    } else if (node->data == "INF") {
        // compare l'inverse
        fprintf(stream, "\tbge IL_%x\n", il);

    } else if (node->data == "INFEQUAL") {
        // compare l'inverse
        fprintf(stream, "\tbgt IL_%x\n", il);

    } else if (node->data == "SUPEQUAL") {
        // compare l'inverse
        fprintf(stream, "\tblt IL_%x\n", il);

    } else if (node->data == "EQUAL") {
        // compare l'inverse
        fprintf(stream, "\tbne.un IL_%x\n", il);

    } else if (node->data == "NOT") {
        // compare l'inverse
        fprintf(stream, "\tbeq IL_%x\n", il);
    }
}

// construit les booleans boolean comme ecrite
void produce_code_litteral(GNode* node) {
    int length = g_queue_get_length(label_queue);
    int il = GPOINTER_TO_INT(g_queue_peek_nth(label_queue, length - 2));
    // expression 1
    produce_code(g_node_nth_child(node, 0));
    // expression 2
    produce_code(g_node_nth_child(node, 1));
    if (node->data == "SUP") {
        // compare l'inverse
        fprintf(stream, "\tbgt IL_%x\n", il);
    } else if (node->data == "INF") {
        // compare l'inverse
        fprintf(stream, "\tblt IL_%x\n", il);
    } else if (node->data == "INFEQUAL") {
        // compare l'inverse
        fprintf(stream, "\tble IL_%x\n", il);
    } else if (node->data == "SUPEQUAL") {
        // compare l'inverse
        fprintf(stream, "\tbge IL_%x\n", il);
    } else if (node->data == "EQUAL") {
        // compare l'inverse
        fprintf(stream, "\tbeq IL_%x\n", il);
    } else if (node->data == "NOT") {
        // compare l'inverse
        fprintf(stream, "\tbne.un IL_%x\n", il);
    }
}

void end_code() {
    fprintf(stream, "\tret\n");
    fprintf(stream,
    "} // end of method %s::Main\n", module_name);
}

int yyerror(const char *msg) {
    fprintf(stderr, "%s\n", msg);
}

int main(int argc, char *argv[]) {
    if (argc == 2) {
        char *file_name_input = argv[1];
        char *extension;
        char *directory_delimiter;
        char *basename;

        // c'est un .facile
        extension = rindex(file_name_input,'.');
        if (!extension || strcmp(extension, ".facile") != 0) {
            fprintf(stderr, "Input filename extension must be'.facile'\n");
            return EXIT_FAILURE;
        }

        // si pas de / cherche \\ dans le path
        directory_delimiter = rindex(file_name_input,'/');
        if (!directory_delimiter) {
            directory_delimiter = rindex(file_name_input,'\\');
        }
        
        // recupere le nom du fichier
        if (directory_delimiter) {
            basename = strdup(directory_delimiter + 1);
        } else {
            basename = strdup(file_name_input);
        }
        
        // met le nom dans module
        module_name = strdup(basename);
        
        // remplace . par fin de chaine
        *rindex(module_name,'.') = '\0';

        // remplace .facile par .il de basename
        strcpy(rindex(basename,'.'), ".il");
    
        // fichier doit commencer _ ou une lettre
        char *onechar = module_name;
        if (!isalpha(*onechar) && *onechar !='_') {
            free(basename);
            fprintf(stderr, "Base input filename must start with a letter or an underscore\n");
            return EXIT_FAILURE;
        }
        onechar++;
        
        // pas de caractere speciaux dans le nom
        while (*onechar) {
            if (!isalnum(*onechar) && *onechar !='_') {
                free(basename);
                fprintf(stderr, "Base input filename cannot contains special characters\n");
                return EXIT_FAILURE;
            }
            onechar++;
        }
        
        if (stdin = fopen(file_name_input, "r")) {
            if (stream = fopen(basename, "w")) {
                table = g_hash_table_new_full(g_str_hash, g_str_equal, free, NULL);
                end_label = g_queue_new();
                label_queue = g_queue_new();
                yyparse();
                g_hash_table_destroy(table);
                fclose(stream);
                fclose(stdin);
            } else {
                // probleme d'ouverture
                free(basename);
                fclose(stdin);
                fprintf(stderr, "Output filename cannot be opened\n");
                return EXIT_FAILURE;
            }
        } else {
            // pas de fichier
            free(basename);
            fprintf(stderr, "Input filename cannot be opened\n");
            return EXIT_FAILURE;
        }
        free(basename);
    } else {
        // pas de fichier en argument
        fprintf(stderr, "No input filename given\n");
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}
