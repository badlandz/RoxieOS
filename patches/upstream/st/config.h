/* config.h — BAUX st terminal v0.1 */
/* Clean, minimal, BAUX-themed terminal */

static char *font = "JetBrains Mono:size=13:antialias=true:autohint=true";
static int borderpx = 5;

/* BAUX toxic color scheme */
static char *colorname[] = {
	/* 8 normal colors */
	"#0e281c", /* 0: deep radioactive green-black */
	"#d4af37", /* 1: toxic gold */
	"#aaacb2", /* 2: muted cyan-gray */
	"#2e482c", /* 3: glowing toxic green */
	"#5c6bc0", /* 4: electric blue */
	"#ba68c8", /* 5: radioactive purple */
	"#26a69a", /* 6: toxic teal */
	"#aaacb2", /* 7: muted cyan-gray */

	/* 8 bright colors */
	"#1b5e20", /* 8: dark toxic green */
	"#f57c00", /* 9: radioactive orange */
	"#aaacb2", /* 10: muted cyan-gray */
	"#4caf50", /* 11: bright toxic green */
	"#7986cb", /* 12: bright electric blue */
	"#ce93d8", /* 13: bright radioactive purple */
	"#4db6ac", /* 14: bright toxic teal */
	"#ffffff", /* 15: pure white */

	[255] = 0,

	/* more colors can be added after 255 to use with DefaultXX */
	"#cccccc", /* 256: cursor */
	"#0e281c", /* 257: rev cursor */
};

unsigned int defaultfg = 2; /* muted cyan-gray */
unsigned int defaultbg = 0; /* deep radioactive green-black */
unsigned int defaultcs = 256; /* cursor */
unsigned int defaultrcs = 257; /* rev cursor */

/* keybindings */
static char *termname = "st-256color";
static unsigned int tabspaces = 4;
static unsigned int blinktimeout = 0;

/* double-click timeout (in milliseconds) between clicks for selection */
static unsigned int doubleclicktimeout = 300;
static unsigned int tripleclicktimeout = 600;
