import gi, time, re
gi.require_version('Gtk', '3.0')
gi.require_version('Wnck', '3.0')

from gi.repository import Gtk, Wnck

while Gtk.events_pending():
    Gtk.main_iteration()

screen = Wnck.Screen.get_default ()
screen.force_update()

firefox_reg = re.compile('.*firefox.*', re.IGNORECASE)

windows = screen.get_windows()
for w in windows:
    print(w.get_name())
    if firefox_reg.match(w.get_name()):
        w.activate(int(time.time()))
        break
