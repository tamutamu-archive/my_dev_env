import cv2
import numpy as np
import pyautogui as pg

s = pg.screenshot()
zentai = cv2.cvtColor(np.array(s),cv2.COLOR_BGR2GRAY)
#target = cv2.imread('./eclipse1.png',cv2.IMREAD_GRAYSCALE)
target = cv2.imread('eclipse_pkg_lbl.png',cv2.IMREAD_GRAYSCALE)


res = cv2.matchTemplate(zentai, target, cv2.TM_CCOEFF_NORMED)

min_val,max_bal,min_loc,top_left = cv2.minMaxLoc(res)
#print(min_val,max_bal,min_loc,top_left)
#cll = (top_left[0], top_left[1] + 153)
cll = (top_left[0] + 13, top_left[1])

pg.click(cll)

pg.typewrite(['f12',':','backspace'])

