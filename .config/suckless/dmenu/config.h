/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int topbar = 1;                      /* -b  option; if 0, dmenu appears at bottom     */
static int centered = 1;                    /* -c option; centers dmenu on screen */
static int min_width = 800;                    /* minimum width when centered */
static const float menu_height_ratio = 4.0f;  /* This is the ratio used in the original calculation */
/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = {
	"Facebook Sans:size=14"
};
static const char *prompt      = NULL;      /* -p  option; prompt to the left of input field */

static const char col_normfg[]        = "#88C0D0";
static const char col_normbg[]       = "#4C566A";
static const char col_selfg[]       = "#A3BE8C";
static const char col_selbg[]        = "#3B4252";

static const char *colors[SchemeLast][2] = {
    /*     fg         bg       */
    [SchemeNorm] = {"#ECEFF4", "#2E3440"},
    [SchemeSel] = {"#D8DEE9", "#434C5E"},
    [SchemeSelHighlight] = {"#8FBCBB", "#434C5E"},
    [SchemeNormHighlight] = {"#81A1C1", "#2E3440"},
    [SchemeOut] = {"#000000", "#00ffff"},
    [SchemeOutHighlight] = { "#ffc978", "#00ffff" },
};
/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines      = 0;
static unsigned int lineheight = 0;
static unsigned int min_lineheight = 8;

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";

/* Size of the window border */
static unsigned int border_width = 5;
