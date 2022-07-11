# OBWH-AHK - This is legal wallhack for cs:go game

Related topic: https://www.unknowncheats.me/forum/cs-go-releases/444489-obwh-ahk.html

CS:GO wallhack achieved by patching one byte of game memory.

This does the same as r_drawothermodels 2 command but without touching the cvar, so it's VAC - safe.

How it works
This program patches assembly code produced by compiling the following line of the game code:

int extraFlags = 0;
if ( r_drawothermodels.GetInt() == 2 )
{	
    extraFlags |= STUDIO_WIREFRAME;	
}
