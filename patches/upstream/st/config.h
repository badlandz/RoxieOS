/* config.h — BAUX st terminal v0.1 */
/* Clean, minimal, BAUX-themed terminal */

static char *font = "JetBrains Mono:size=13:antialias=true:autohint=true";
static int borderpx = 5;

/* BAUX Gruvbox Dark color scheme */
static char *colorname[] = {
 	/* 8 normal colors */
 	"#282828", /* 0: gruvbox bg */
 	"#cc241d", /* 1: gruvbox red */
 	"#98971a", /* 2: gruvbox green */
 	"#d79921", /* 3: gruvbox yellow */
 	"#458588", /* 4: gruvbox blue */
 	"#b16286", /* 5: gruvbox purple */
 	"#689d6a", /* 6: gruvbox aqua */
 	"#a89984", /* 7: gruvbox gray */

 	/* 8 bright colors */
 	"#928374", /* 8: gruvbox gray bright */
 	"#fb4934", /* 9: gruvbox red bright */
 	"#b8bb26", /* 10: gruvbox green bright */
 	"#fabd2f", /* 11: gruvbox yellow bright */
 	"#83a598", /* 12: gruvbox blue bright */
 	"#d3869b", /* 13: gruvbox purple bright */
 	"#8ec07c", /* 14: gruvbox aqua bright */
 	"#ebdbb2", /* 15: gruvbox fg */

 	[255] = 0,

 	/* more colors can be added after 255 to use with DefaultXX */
 	"#ebdbb2", /* 256: cursor */
 	"#282828", /* 257: rev cursor */
};

unsigned int defaultfg = 15; /* gruvbox fg */
unsigned int defaultbg = 0; /* gruvbox bg */
unsigned int defaultcs = 256; /* cursor */
unsigned int defaultrcs = 257; /* rev cursor */

/* keybindings */
static char *termname = "st-256color";
static unsigned int tabspaces = 4;
static unsigned int blinktimeout = 0;

/* double-click timeout (in milliseconds) between clicks for selection */
static unsigned int doubleclicktimeout = 300;
static unsigned int tripleclicktimeout = 600;
