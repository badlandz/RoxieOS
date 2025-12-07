/* config.h — bauxwm v0.1 "Roxanne Cyberdeck" */
/* No mouse. No mercy. Only layers. */
/* Mod4 = dwm | Alt = tmux | hjkl = vim */

static const unsigned int borderpx  = 5;        /* thick toxic border */
static const unsigned int gappx     = 5;        /* gap pixel between windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 = no bar */
static const int topbar             = 0;        /* 0 = bottom bar (cleaner) */
static const int smartgaps          = 0;        /* 1 = no gaps when only one window */
static const char *fonts[]          = { "monospace:size=13" };
static const char dmenufont[]       = "monospace:size=13";

/* BAUX Gruvbox Dark color scheme — unified theming */
static const char col_bg[]          = "#282828";  /* gruvbox bg */
static const char col_border[]      = "#282828";  /* gruvbox bg */
static const char col_text[]        = "#ebdbb2";  /* gruvbox fg */
static const char col_seltext[]     = "#282828";  /* gruvbox bg */
static const char col_selbg[]       = "#cc241d";  /* gruvbox red */

static const char *colors[][3] = {
       /*               fg         bg         border   */
       [SchemeNorm] = { col_text,    col_bg,      col_border },
       [SchemeSel]  = { col_seltext, col_selbg,   col_selbg  },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
       /* class      instance    title       tags mask     isfloating   monitor */
       { "Gimp",     NULL,       NULL,       0,            1,          -1 },
       { "Firefox",  NULL,       NULL,       1 << 8,       0,          -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* master area size */
static const int nmaster     = 1;    /* clients in master */
static const int resizehints = 1;    /* respect size hints in tiled */
static const int lockfullscreen = 1; /* force focus on fullscreen */
static const int refreshrate = 120;  /* refresh rate (per second) for client move/resize */
static const Layout layouts[] = {
       { "[]=",      tile },    /* default */
       { "><>",      NULL },    /* floating */
       { "[M]",      monocle },
};

/* key definitions — LAYERS OF CONTROL */
#define MODKEY Mod4Mask    /* Super/Win/Opt — dwm layer */
#define TAGKEYS(KEY,TAG) \
       { MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
       { MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
       { MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
       { MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

static char dmenumon[2] = "0";
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont,
                                 "-nb", col_bg, "-nf", col_text, "-sb", col_selbg, "-sf", col_seltext, NULL };
static const char *termcmd[]  = { "alacritty", NULL };  /* alacritty termina — baux shell */
static const char *bauxstatuscmd[] = { "/usr/local/bin/status.sh", NULL };

static const Key keys[] = {
       /* modifier            key        function        argument */
       { MODKEY,              XK_p,      spawn,          {.v = dmenucmd } },
       { MODKEY|ShiftMask,    XK_Return, spawn,          {.v = termcmd } },
       { MODKEY,              XK_c,      spawn,          SHCMD("chaos") },
       { MODKEY,              XK_s,      spawn,          {.v = bauxstatuscmd } },
       { MODKEY,              XK_b,      togglebar,      {0} },
       { MODKEY,              XK_j,      focusstack,     {.i = +1 } },
       { MODKEY,              XK_k,      focusstack,     {.i = -1 } },
       { MODKEY,              XK_i,      incnmaster,     {.i = +1 } },
       { MODKEY,              XK_d,      incnmaster,     {.i = -1 } },
       { MODKEY,              XK_h,      setmfact,       {.f = -0.05} },
       { MODKEY,              XK_l,      setmfact,       {.f = +0.05} },
       { MODKEY,              XK_Return, zoom,           {0} },
       { MODKEY,              XK_Tab,    view,           {0} },
       { MODKEY|ShiftMask,    XK_c,      killclient,     {0} },
       { MODKEY,              XK_t,      setlayout,      {.v = &layouts[0]} },
       { MODKEY,              XK_f,      setlayout,      {.v = &layouts[1]} },
       { MODKEY,              XK_m,      setlayout,      {.v = &layouts[2]} },
       { MODKEY,              XK_space,  setlayout,      {0} },
       { MODKEY|ShiftMask,    XK_space,  togglefloating, {0} },
       { MODKEY,              XK_0,      view,           {.ui = ~0 } },
       { MODKEY|ShiftMask,    XK_0,      tag,            {.ui = ~0 } },
       { MODKEY,              XK_comma,  focusmon,       {.i = -1 } },
       { MODKEY,              XK_period, focusmon,       {.i = +1 } },
       { MODKEY|ShiftMask,    XK_comma,  tagmon,         {.i = -1 } },
       { MODKEY|ShiftMask,    XK_period, tagmon,         {.i = +1 } },
       TAGKEYS(               XK_1,      0)
       TAGKEYS(               XK_2,      1)
       TAGKEYS(               XK_3,      2)
       TAGKEYS(               XK_4,      3)
       TAGKEYS(               XK_5,      4)
       TAGKEYS(               XK_6,      5)
       TAGKEYS(               XK_7,      6)
       TAGKEYS(               XK_8,      7)
       TAGKEYS(               XK_9,      8)
       { MODKEY|ShiftMask,    XK_q,      quit,           {0} },
};

/* button definitions */
static const Button buttons[] = {
       { ClkLtSymbol,         0,         Button1,        setlayout,      {0} },
       { ClkLtSymbol,         0,         Button3,        setlayout,      {.v = &layouts[2]} },
       { ClkWinTitle,         0,         Button2,        zoom,           {0} },
       { ClkStatusText,       0,         Button2,        spawn,          {.v = termcmd } },
       { ClkClientWin,        MODKEY,    Button1,        movemouse,      {0} },
       { ClkClientWin,        MODKEY,    Button2,        togglefloating, {0} },
       { ClkClientWin,        MODKEY,    Button3,        resizemouse,    {0} },
       { ClkTagBar,           0,         Button1,        view,           {0} },
       { ClkTagBar,           0,         Button3,        toggleview,     {0} },
       { ClkTagBar,           MODKEY,    Button1,        tag,            {0} },
       { ClkTagBar,           MODKEY,    Button3,        toggletag,      {0} },
};
