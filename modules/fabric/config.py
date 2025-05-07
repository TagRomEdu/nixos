import os
import time
import json
import subprocess
import psutil
from loguru import logger
from fabric import Application
from fabric.widgets.box import Box
from fabric.widgets.label import Label
from fabric.widgets.datetime import DateTime
from fabric.widgets.wayland import WaylandWindow as Window
from fabric.widgets.button import Button
from fabric.utils import invoke_repeater, get_relative_path


class SidePanel(Window):
    def __init__(self, **kwargs):
        super().__init__(
            layer="overlay",
            title="fabric-overlay",
            anchor="top right",
            exclusivity="none",
            visible=False,
            all_visible=False,
            **kwargs,
        )

        self.profile_pic = Box(name="profile-pic", children=[])
        pic_path = os.path.expanduser("/home/lysec/nixos/assets/icons/nix-catppuccin.png")
        if os.path.exists(pic_path):
            self.profile_pic.set_style(f"background-image: url('file://{pic_path}')")
        else:
            logger.warning("Custom icon not found at '/home/lysec/nixos/assets/icons/nix-catppuccin.png'")

        self.os_age_label = Label(label=f"OS Age: {self.get_os_age()}", name="os-age-label")

        self.header = Box(
            name="header",
            orientation="h",
            children=[
                self.profile_pic,
                Box(
                    orientation="v",
                    children=[
                        DateTime(name="date-time", format="%T"),
                        self.os_age_label,
                    ],
                ),
            ],
        )

        self.greeter_label = Label(
            name="greeter-label",
            label=f"🐐 Good {'Morning' if time.localtime().tm_hour < 12 else 'Afternoon'}, {os.getlogin().title()}!",
        )

        self.rebuild_label = self.create_rebuild_label()


        self.progress_container = Box(
            name="progress-bar-container",
            orientation="v",
            children=[
                self.rebuild_label,
            ],
        )

        def make_button(name, icon, tooltip):
            btn = Button(name=name, label=icon, tooltip_text=tooltip)
            btn.add_style_class("control-button")
            return btn
        self.logout_button = make_button("logout-button", "", "Logout")  # Logout icon
        self.logout_button.connect("clicked", self.on_logout_click)

        self.lock_button = make_button("lock-button", "", "Lock")  # Lock icon
        self.lock_button.connect("clicked", self.on_lock_click)

        self.reboot_button = make_button("reboot-button", "", "Reboot")  # Reboot icon
        self.reboot_button.connect("clicked", self.on_reboot_click)

        self.shutdown_button = make_button("shutdown-button", "⏻", "Shutdown")  # Shutdown icon
        self.shutdown_button.connect("clicked", self.on_shutdown_click)

        self.control_buttons = Box(
            name="control-buttons-container",
            orientation="h",
            children=[
                self.logout_button,
                Box(name="control-button-sep"),
                self.lock_button,
                Box(name="control-button-sep"),
                self.reboot_button,
                Box(name="control-button-sep"),
                self.shutdown_button,
            ],
        )

        self.add(
            Box(
                name="window-inner",
                orientation="v",
                children=[
                    self.header,
                    self.greeter_label,
                    self.progress_container,
                    self.control_buttons,
                ],
            ),
        )
        self.show_all()

    def create_rebuild_label(self):
        rebuild_info_path = "/var/log/nixos-rebuild-log.json"
        if os.path.exists(rebuild_info_path):
            try:
                with open(rebuild_info_path, "r") as f:
                    rebuild_info = json.load(f)
                rebuild_time = rebuild_info.get("last_rebuild", "Unknown")
                generation = rebuild_info.get("generation", "N/A")
                return Label(name="rebuild-label", label=f"Last rebuild: {rebuild_time}\nGeneration: {generation}")
            except Exception as e:
                logger.warning(f"Failed to load rebuild info: {e}")
                return Label(name="rebuild-label", label="Last rebuild: Error loading data")
        else:
            return Label(name="rebuild-label", label="Last rebuild: Log not found")

    def on_logout_click(self, button):
        subprocess.run(["hyprctl", "dispatch", "exit"], check=True)

    def on_lock_click(self, button):
        logger.info("Lock clicked")

    def on_reboot_click(self, button):
        subprocess.run("reboot", check=True)

    def on_shutdown_click(self, button):
        logger.info("Shutdown clicked")

    def get_os_age(self):
        try:
            stat_output = subprocess.check_output(['stat', '-c', '%W', '/']).decode('utf-8').strip()
            birth_install = int(stat_output)
            current = int(time.time())
            time_progression = current - birth_install
            days_difference = time_progression // 86400
            return f"{days_difference} days"
        except Exception as e:
            logger.warning(f"Failed to calculate OS age: {e}")
            return "Unknown"

    def on_close(self):
        try:
            if hasattr(self, 'progress_container'):
                self.progress_container.destroy()
            logger.info("SidePanel closed and cleaned up successfully.")
        except Exception as e:
            logger.warning(f"Error while cleaning up widgets: {e}")
        super().on_close()


if __name__ == "__main__":
    panel = SidePanel()
    app = Application("side-panel", panel)
    app.set_stylesheet_from_file(get_relative_path("./style.css"))
    app.run()
