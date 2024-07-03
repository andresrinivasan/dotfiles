#!/usr/bin/env python3

import sys

import iterm2


async def main(connection):
    p = sys.argv[1]
    if p == "ITERM_DEFAULT_PROFILE":
        p = None

    if len(sys.argv) > 2:
        d = sys.argv[2]
        l = iterm2.LocalWriteOnlyProfile()
        l.set_initial_directory_mode(
            iterm2.InitialWorkingDirectory.INITIAL_WORKING_DIRECTORY_CUSTOM
        )
        l.set_custom_directory(d)
    else:
        l = None

    w = await iterm2.Window.async_create(connection, p, profile_customizations=l)
    await w.async_activate()  # Not sufficient to always raise the window

    a = await iterm2.async_get_app(connection)
    await a.async_activate(False, True)  # Raise only current active window


if __name__ == "__main__":
    iterm2.run_until_complete(main)
