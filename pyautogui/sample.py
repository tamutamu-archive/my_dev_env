import cv2
import numpy as np
import pyautogui as pg

s = pg.screenshot()
zentai = cv2.cvtColor(np.array(s),cv2.COLOR_BGR2GRAY)
target = cv2.imread('/home/tamutamu/target.png',cv2.IMREAD_GRAYSCALE)

res = cv2.matchTemplate(zentai, target, cv2.TM_CCOEFF_NORMED)

min_val,max_bal,min_loc,top_left = cv2.minMaxLoc(res)
cll = (top_left[0] + 52, top_left[1] + 42)

print(cll)

pg.click(cll)
