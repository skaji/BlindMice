#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#define NEED_gv_fetchpvn_flags
#include "ppport.h"

/* Global Data */
#define MY_CXT_KEY "BlindMice::_guts" XS_VERSION

typedef struct {
    int count;
    char name[3][100];
} my_cxt_t;

START_MY_CXT

MODULE = BlindMice  PACKAGE = BlindMice

BOOT:
{
    MY_CXT_INIT;
    MY_CXT.count = 0;
    strcpy(MY_CXT.name[0], "None");
    strcpy(MY_CXT.name[1], "None");
    strcpy(MY_CXT.name[2], "None");
}

int
newMouse(char * name)
    PREINIT:
      dMY_CXT;
    CODE:
      if (MY_CXT.count >= 3) {
          warn("Already have 3 blind mice");
          RETVAL = 0;
      }
      else {
          RETVAL = ++ MY_CXT.count;
          strcpy(MY_CXT.name[MY_CXT.count - 1], name);
      }
    OUTPUT:
      RETVAL

char *
get_mouse_name(index)
      int index
    PREINIT:
      dMY_CXT;
    CODE:
      if (index > MY_CXT.count)
        croak("There are only 3 blind mice.");
      else
        RETVAL = MY_CXT.name[index - 1];
    OUTPUT:
      RETVAL

void
CLONE(...)
    CODE:
      MY_CXT_CLONE;
