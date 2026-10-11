import gi

gi.require_version("Gtk", "3.0")
gi.require_version("GtkLayerShell", "0.1")

from datetime import datetime

from gi.repository import GLib, Gtk, GtkLayerShell


class Bar(Gtk.Window):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)

        GtkLayerShell.init_for_window(self)
        GtkLayerShell.set_namespace(self, "noodle-shell")
        GtkLayerShell.set_layer(self, GtkLayerShell.Layer.TOP)
        GtkLayerShell.auto_exclusive_zone_enable(self)
        for edge in (
            GtkLayerShell.Edge.TOP,
            GtkLayerShell.Edge.LEFT,
            GtkLayerShell.Edge.RIGHT,
        ):
            GtkLayerShell.set_anchor(self, edge, True)

        self.clock = Gtk.Label()
        self.add(self.clock)

        self._tick()
        GLib.timeout_add_seconds(1, self._tick)

    def _tick(self):
        self.clock.set_text(datetime.now().strftime("%a %Y-%m-%d  %H:%M:%S"))
        return True
