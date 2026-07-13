#include <X11/XF86keysym.h>
#include <X11/keysym.h>

/* appearance */
static unsigned int borderpx  = 1;        /* border pixel of windows */
static unsigned int snap      = 32;       /* snap pixel */
static int showbar            = 1;        /* 0 means no bar */
static int topbar             = 1;        /* 0 means bottom bar */
static const char font[] = "Monospace, Matangi SemiBold 10";
static char normbgcolor[]           = "#222222";
static char normbordercolor[]       = "#444444";
static char normfgcolor[]           = "#bbbbbb";
static char selfgcolor[]            = "#eeeeee";
static char selbordercolor[]        = "#005577";
static char selbgcolor[]            = "#005577";
static char *colors[][3] = {
    /*               fg           bg           border   */
    [SchemeNorm] = { normfgcolor, normbgcolor, normbordercolor },
    [SchemeSel]  = { selfgcolor,  selbgcolor,  selbordercolor  },
};

/* tagging */
static const char *tags[] = { "१", "२", "३", "४", "५", "६", "७", "८", "९" };


static const Rule rules[] = {
    /* xprop(1):
     *	WM_CLASS(STRING) = instance, class
     *	WM_NAME(STRING) = title
     */
    /* class      instance    title       tags mask     isfloating   monitor  isgame */

    { "Gimp",     NULL,       NULL,       0,            1,           -1 },
    { "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
    { "St",       NULL,       NULL,       1 << 7,       0,           -1 },
    { "St",       NULL,       NULL,       1 << 7,       0,           -1 },
    { "Steam",    NULL,       NULL,       0,            0,           -1,      1 },
    { "steam_app",NULL,       NULL,       0,            0,           -1,      1 },
    { "QtCreator",NULL,       NULL,       1 << 6,       0,           -1 },
};

/* layout(s) */
static float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static int nmaster     = 1;    /* number of clients in master area */
static int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */
static const int refreshrate = 120;  /* refresh rate (per second) for client move/resize */

static const Layout layouts[] = {
    /* symbol     arrange function */
    { "[]=",      tile },    /* first entry is default */
    { "><>",      NULL },    /* no layout function means floating behavior */
    { "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */

/*
 * Xresources preferences to load at startup
 */
ResourcePref resources[] = {
    { "background",         STRING,  &normbgcolor },
    { "background",         STRING,  &normbordercolor },
    { "foreground",         STRING,  &normfgcolor },
    { "foreground",         STRING,  &selbgcolor },
    { "foreground",         STRING,  &selbordercolor },
    { "background",         STRING,  &selfgcolor },
    { "borderpx",          	INTEGER, &borderpx },
    { "snap",          		INTEGER, &snap },
    { "showbar",          	INTEGER, &showbar },
    { "topbar",          	INTEGER, &topbar },
    { "nmaster",          	INTEGER, &nmaster },
    { "resizehints",       	INTEGER, &resizehints },
    { "mfact",      	 	FLOAT,   &mfact },
};

//static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbordercolor, "-sf", selfgcolor, NULL };
//
static const char *dmenucmd[] = { "dmenu_run", "-p", "select: ", "-m", dmenumon  };
static const char *termcmd[]  = { "st", NULL };

static const Key keys[] = {
    /* modifier                     key            function                argument */
    { MODKEY,                       XK_b,          togglebar,              {0} },
    { MODKEY,                       XK_h,          focusstack,             {.i = +1 } },
    { MODKEY,                       XK_l,          focusstack,             {.i = -1 } },
    { MODKEY,                       XK_i,          incnmaster,             {.i = +1 } },
    { MODKEY,                       XK_u,          incnmaster,             {.i = -1 } },
    { MODKEY,                       XK_j,          setmfact,               {.f = -0.05} },
    { MODKEY,                       XK_k,          setmfact,               {.f = +0.05} },
    { MODKEY|ShiftMask,             XK_Return,     zoom,                   {0} },
    { MODKEY,                       XK_Tab,        view,                   {0} },
    { MODKEY,                       XK_p,          killclient,             {0} },
    { MODKEY|ShiftMask,             XK_q,          quit,                   {0} },
    { MODKEY,                       XK_F5,         xrdb,                   {.v = NULL } },
    { MODKEY,                       XK_t,          setlayout,              {.v = &layouts[0]} },
    { MODKEY,                       XK_f,          setlayout,              {.v = &layouts[1]} },
    { MODKEY,                       XK_o,          setlayout,              {.v = &layouts[2]} },
    { MODKEY,                       XK_space,      setlayout,              {0} },
    { MODKEY|ShiftMask,             XK_space,      togglefloating,         {0} },
    { MODKEY,                       XK_0,          view,                   {.ui = ~0 } },
    { MODKEY|ShiftMask,             XK_0,          tag,                    {.ui = ~0 } },
    { MODKEY,                       XK_1,          focusmon,               {.i = -1 } },
    { MODKEY,                       XK_2,          focusmon,               {.i = +1 } },
    { MODKEY|ShiftMask,             XK_1,          tagmon,                 {.i = -1 } },
    { MODKEY|ShiftMask,             XK_2,          tagmon,                 {.i = +1 } },

    TAGKEYS(                        XK_n,                                  0)
        TAGKEYS(                        XK_m,                                  1)
        TAGKEYS(                        XK_comma,                              2)
        TAGKEYS(                        XK_period,                             3)
        TAGKEYS(                        XK_slash,                              4)
        TAGKEYS(                        XK_6,                                  5)
        TAGKEYS(                        XK_7,                                  6)
        TAGKEYS(                        XK_8,                                  7)
        TAGKEYS(                        XK_9,                                  8)
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
    /* click                event mask      button          function        argument */
    { ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
    { ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
    { ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
    { ClkWinTitle,          0,              Button2,        zoom,           {0} },
    { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
    { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
    { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
    { ClkTagBar,            0,              Button1,        view,           {0} },
    { ClkTagBar,            0,              Button3,        toggleview,     {0} },
    { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
    { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

