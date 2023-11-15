#include "utils.h"
#include "stdlib.h"
#include "string.h"

static variable_node* variable_table;

variable_node* get_variable(const char* name) {
    variable_node* tmp = variable_table;

    while(tmp != NULL) {
        if(strcmp(tmp->name, name) == 0) {
            break;
        }
        tmp = tmp->next;
    }

    return tmp;
}

variable_node* create_variable(const char* name, double value) {
    variable_node* new_node = malloc(sizeof(variable_node));
    new_node->name = name;
    new_node->value = value;
}

void add_variable(const char* name, double value)
{
    variable_node* found = get_variable(name);
    if(found != NULL) {
        found->value = value;
        return;
    }

    found = create_variable(name, value);
    found->next = variable_table;
    variable_table = found;
}

void init_variable_table() {
    variable_table = create_variable("z", 0);
    variable_table->next = NULL;
}