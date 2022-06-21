#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"

#define SIZE 200 
#define MAXTOKENLEN 40
#define SHIFT 4

static int hash ( char * key )
{ int temp = 0;
  int i = 0;
  while (key[i] != '\0')
  { temp = ((temp << SHIFT) + key[i]) % SIZE;
    ++i;
  }
  return temp;
}

typedef struct RefListRec { 
     int lineno;
     struct RefListRec * next;
     /* ADDED */
     int type;
} * RefList;

typedef struct HashRec { 
     char st_name[MAXTOKENLEN];
     int st_size;
     RefList lines;
     int st_value;
     
     int st_type;
     struct HashRec * next;
} * Node;


static Node hashTable[SIZE];

 
void insert( char * name, int type, int lineno )
{ 
 
  int h = hash(name);
  Node l =  hashTable[h];
  int len=strlen(name);
while ((l != NULL) && (strcmp(name,l->st_name) != 0))
    l = l->next;
  if (l == NULL) 
  { l = (Node) malloc(sizeof(struct HashRec));
    strncpy(l->st_name, name, len);  
    
    l->st_type = type;
    l->lines = (RefList) malloc(sizeof(struct RefListRec));
l->lines->lineno = lineno;
    l->lines->next = NULL;
    l->next = hashTable[h];
    hashTable[h] = l; }
  else 
  { RefList t = l->lines;
    while (t->next != NULL) t = t->next;
    t->next = (RefList) malloc(sizeof(struct RefListRec));
    t->next->lineno = lineno;
    t->next->next = NULL;
  }
} 


int lookup ( char * name )
{ int h = hash(name);
  Node l =  hashTable[h];
  while ((l != NULL) && (strcmp(name,l->st_name) != 0))
    l = l->next;
  if (l == NULL) return -1 ;
  else return l->st_value;
}


int lookupType( char * name )
{
  int h = hash(name);
  Node l =  hashTable[h];
  while ((l != NULL) && (strcmp(name,l->st_name) != 0))
    l = l->next;
  if (l == NULL) return -1;
  else return l->st_type;
}


int setType( char * name, int t )
{
   int h = hash(name);
   Node l =  hashTable[h];
   while ((l != NULL) && (strcmp(name,l->st_name) != 0))
     l = l->next;
   if (l == NULL) return -1;
   else {
     l->st_type = t;
     return 0;
   }
}

/* print to stdout by default */ 
void symtab_dump(FILE * of) {  
  int i;
  fprintf(of,"------------ ------ ------------\n");
  fprintf(of,"Name         Type   Line Numbers\n");
  fprintf(of,"------------ ------ -------------\n");
  for (i=0; i < SIZE; ++i)
  { if (hashTable[i] != NULL)
    { Node l = hashTable[i];
      while (l != NULL)
      { RefList t = l->lines;
        fprintf(of,"%-12s ",l->st_name);

        if (l->st_type == INT_TYPE)
           fprintf(of,"%-7s","int ");
        if (l->st_type == REAL_TYPE)
           fprintf(of,"%-7s","real");
        if (l->st_type == STR_TYPE)
           fprintf(of,"%-7s","string");


        while (t != NULL)
        { fprintf(of,"%4d ",t->lineno);
          t = t->next;
        }
fprintf(of,"\n");
        l = l->next;
      }
    }
  }
} 