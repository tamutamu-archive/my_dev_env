import pyautogui as pg
import time,sys

pg.FAILSAFE = True

pg.keyDown('shift')
pg.keyDown('altleft')
pg.keyDown('q')
pg.keyUp('shift')
pg.keyUp('altleft')
pg.keyUp('q')

pg.press('p')
