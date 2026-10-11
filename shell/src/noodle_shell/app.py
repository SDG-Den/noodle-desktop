import sys

import gi

gi.require_version("Gtk", "3.0")

from gi.repository import Gtk

from noodle_shell.bar import Bar


class NoodleShell(Gtk.Application):
    def __init__(self):
        super().__init__(application_id="dev.noodle.shell")

    def do_activate(self):
        Bar(application=self).show_all()


def main():
    return NoodleShell().run(sys.argv)
