#!/usr/bin/python3

from gi.repository import Gio, GLib
import subprocess
import sys


POWER_BUS = "org.freedesktop.UPower.PowerProfiles"
POWER_PATH = "/org/freedesktop/UPower/PowerProfiles"
POWER_IFACE = "org.freedesktop.UPower.PowerProfiles"

LOGIN_BUS = "org.freedesktop.login1"
LOGIN_PATH = "/org/freedesktop/login1"
LOGIN_IFACE = "org.freedesktop.login1.Manager"

OUTPUT = "eDP-1"

MODES = {
    "performance": "1920x1080@60.049",
    "balanced": "1920x1080@60.049",
    "power-saver": "1920x1080@48.040",
}

last_mode = None


def apply_profile(force=False):
    global last_mode

    profile_variant = power_proxy.get_cached_property("ActiveProfile")

    if profile_variant is None:
        print("Could not read ActiveProfile from tlp-pd.", file=sys.stderr)
        return GLib.SOURCE_REMOVE

    profile = profile_variant.unpack()
    mode = MODES.get(profile)

    if mode is None:
        print(f"Unknown power profile: {profile}", file=sys.stderr)
        return GLib.SOURCE_REMOVE

    if not force and mode == last_mode:
        return GLib.SOURCE_REMOVE

    result = subprocess.run(
        ["niri", "msg", "output", OUTPUT, "mode", mode],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.PIPE,
        text=True,
    )

    if result.returncode == 0:
        last_mode = mode
        print(f"{profile}: {OUTPUT} -> {mode}", flush=True)
    else:
        print(
            f"Failed to set {OUTPUT} to {mode}: {result.stderr.strip()}",
            file=sys.stderr,
        )

    return GLib.SOURCE_REMOVE


def on_profile_changed(proxy, changed_properties, invalidated_properties):
    apply_profile()


def on_power_daemon_owner_changed(proxy, pspec):
    if proxy.get_name_owner():
        GLib.idle_add(apply_profile, True)


def reapply_after_resume():
    apply_profile(force=True)
    return GLib.SOURCE_REMOVE


def on_login_signal(proxy, sender_name, signal_name, parameters):
    if signal_name != "PrepareForSleep":
        return

    going_to_sleep = parameters.unpack()[0]

    if not going_to_sleep:
        # Give the compositor/output a moment to settle after resume.
        GLib.timeout_add_seconds(1, reapply_after_resume)


power_proxy = Gio.DBusProxy.new_for_bus_sync(
    Gio.BusType.SYSTEM,
    Gio.DBusProxyFlags.NONE,
    None,
    POWER_BUS,
    POWER_PATH,
    POWER_IFACE,
    None,
)

login_proxy = Gio.DBusProxy.new_for_bus_sync(
    Gio.BusType.SYSTEM,
    Gio.DBusProxyFlags.NONE,
    None,
    LOGIN_BUS,
    LOGIN_PATH,
    LOGIN_IFACE,
    None,
)

power_proxy.connect("g-properties-changed", on_profile_changed)
power_proxy.connect("notify::g-name-owner", on_power_daemon_owner_changed)

login_proxy.connect("g-signal", on_login_signal)

# Apply the correct refresh rate immediately at startup.
apply_profile(force=True)

GLib.MainLoop().run()
