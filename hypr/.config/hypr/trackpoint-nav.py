#!/usr/bin/env python3
import evdev
import subprocess
import threading
import time

THRESHOLD = 30
COOLDOWN = 0.3

def find_device(name):
    for path in evdev.list_devices():
        dev = evdev.InputDevice(path)
        if name in dev.name:
            return dev
    return None

keyboard = find_device("keyd virtual keyboard")
pointer  = find_device("keyd virtual pointer")

if not keyboard or not pointer:
    print("keyd virtual devices not found")
    exit(1)

print(f"keyboard: {keyboard.name}, pointer: {pointer.name}")

super_held = False
acc_x = 0
acc_y = 0
last_trigger = 0

def watch_keyboard():
    global super_held, acc_x, acc_y
    for event in keyboard.read_loop():
        if event.type == evdev.ecodes.EV_KEY and event.code == evdev.ecodes.KEY_LEFTMETA:
            super_held = event.value == 1
            if not super_held:
                acc_x = 0
                acc_y = 0

threading.Thread(target=watch_keyboard, daemon=True).start()

for event in pointer.read_loop():
    if not super_held:
        continue
    if event.type != evdev.ecodes.EV_REL:
        continue

    if event.code == evdev.ecodes.REL_X:
        acc_x += event.value
    elif event.code == evdev.ecodes.REL_Y:
        acc_y += event.value

    now = time.monotonic()
    if now - last_trigger < COOLDOWN:
        continue

    if abs(acc_x) >= THRESHOLD or abs(acc_y) >= THRESHOLD:
        if abs(acc_x) >= abs(acc_y):
            direction = "r" if acc_x > 0 else "l"
        else:
            direction = "d" if acc_y > 0 else "u"
        subprocess.Popen(["hyprctl", "dispatch", "movefocus", direction])
        acc_x = 0
        acc_y = 0
        last_trigger = now
