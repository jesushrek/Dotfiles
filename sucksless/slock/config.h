/* user and group to drop privileges to */
static const char *user  = "nobody";
static const char *group = "nogroup";

static const char *colorname[NUMCOLS] = {
    [BACKGROUND] = "white",
    [INIT] =   "black",     /* after initialization */
    [INPUT] =  "#005577",   /* during input */
    [FAILED] = "#CC3333",   /* wrong password */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;

static const int logosize = 75;
static const int logow = 12; /* Grid width and height for right center alignment*/
static const int logoh = 6;


/*
 * Xresources preferences to load at startup
 */

ResourcePref resources[] = {
    { "foreground",       STRING,  &colorname[INIT] },
    { "color4",       STRING,  &colorname[INPUT] },
    { "color1",       STRING,  &colorname[FAILED] },
    { "color0",       STRING,  &colorname[BACKGROUND] },
};

/* treat a cleared input like a wrong password (color) */

static XRectangle rectangles[9] = {
    {0, 0, 0, 0},
    {0, 0, 0, 0},
    {0, 0, 0, 0},
    {0, 0, 0, 0},
    {0, 0, 0, 0},
    {0, 0, 0, 0},
    {0, 0, 0, 0},
    {0, 0, 0, 0},
    {0, 0, 0, 0},
};

//Game of life simulation variables

#define GOL_UPDATE_MS 120
#define CELL_SIZE 3


/*Enable blur*/
#define BLUR
/*Set blur radius*/
static const int blurRadius=5;
/*Enable Pixelation*/
//#define PIXELATION
/*Set pixelation radius*/
static const int pixelSize=0;
