import os
import time
import psutil
from loguru import logger
from fabric import Application
from fabric.widgets.box import Box
from fabric.widgets.label import Label
from fabric.widgets.overlay import Overlay
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
            margin="10px 10px 10px 0px",
            exclusivity="none",
            visible=False,
            all_visible=False,
            **kwargs,
        )

        # Set the custom icon instead of the profile picture
        self.profile_pic = Box(name="profile-pic", children=[])
        pic_path = os.path.expanduser("/home/lysec/nixos/assets/icons/nix-catppuccin.png")  # Updated path
        if os.path.exists(pic_path):
            self.profile_pic.set_style(f"background-image: url('file://{pic_path}')")
        else:
            logger.warning("Custom icon not found at '~/nixos/assets/icon/test.png'")

        self.uptime_label = Label(label=f"{self.get_current_uptime()}")

        self.header = Box(
            name="header",
            orientation="h",
            children=[
                self.profile_pic,
                Box(
                    orientation="v",
                    children=[
                        DateTime(name="date-time"),
                        self.uptime_label,
                    ],
                ),
            ],
        )

        self.greeter_label = Label(
            name="greeter-label",
            label=f"Good {'Morning' if time.localtime().tm_hour < 12 else 'Afternoon'}, {os.getlogin().title()}!",
        )

        self.progress_container = Box(
            name="progress-bar-container",
            children=[
                Label(label="Hello Fabric <3"),
            ],
        )

        # Control Buttons (no text, icon only)
        def make_button(name, icon, tooltip):
            btn = Button(name=name, label=icon, tooltip_text=tooltip)
            btn.add_style_class("control-button")
            return btn

        self.logout_button = make_button("logout-button", "", "Logout")
        self.logout_button.connect("clicked", self.on_logout_click)

        self.lock_button = make_button("lock-button", "󰍹", "Lock")
        self.lock_button.connect("clicked", self.on_lock_click)

        self.reboot_button = make_button("reboot-button", "", "Reboot")
        self.reboot_button.connect("clicked", self.on_reboot_click)

        self.shutdown_button = make_button("shutdown-button", "", "Shutdown")
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

    def update_uptime_label(self):
        self.uptime_label.set_label(self.get_current_uptime())

    def on_logout_click(self, button):
        logger.info("Logout clicked")

    def on_lock_click(self, button):
        logger.info("Lock clicked")

    def on_reboot_click(self, button):
        logger.info("Reboot clicked")

    def on_shutdown_click(self, button):
        logger.info("Shutdown clicked")

    def get_current_uptime(self):
        uptime = time.time() - psutil.boot_time()
        days, rem = divmod(uptime, 86400)
        hours, _ = divmod(rem, 3600)
        return f"{int(days)} {'days' if days != 1 else 'day'}, {int(hours)} {'hours' if hours != 1 else 'hour'}"


if __name__ == "__main__":
    panel = SidePanel()
    app = Application("side-panel", panel)
    app.set_stylesheet_from_file(get_relative_path("./style.css"))
    app.run()
from fabric.widgets.datetime import DateTime

class SidePanel(Window):
    def __init__(self, **kwargs):
        super().__init__(
            layer="overlay",
            title="fabric-overlay",
            anchor="top right",
            margin="10px 10px 10px 0px",
            exclusivity="none",
            visible=False,
            all_visible=False,
            **kwargs,
        )

        # Set the custom icon instead of the profile picture
        self.profile_pic = Box(name="profile-pic", children=[])
        pic_path = os.path.expanduser("/home/lysec/nixos/assets/icons/nix-catppuccin.png")  # Updated path
        if os.path.exists(pic_path):
            self.profile_pic.set_style(f"background-image: url('file://{pic_path}')")
        else:
            logger.warning("Custom icon not found at '/home/lysec/nixos/assets/icons/nix-catppuccin.png'")

        self.uptime_label = Label(label=f"{self.get_current_uptime()}")

        self.header = Box(
            name="header",
            orientation="h",
            children=[
                self.profile_pic,
                Box(
                    orientation="v",
                    children=[
                        DateTime(name="date-time", format="%H:%M:%S"),  # 24-hour time format
                        self.uptime_label,
                    ],
                ),
            ],
        )

        self.greeter_label = Label(
            name="greeter-label",
            label=f"Good {'Morning' if time.localtime().tm_hour < 12 else 'Afternoon'}, {os.getlogin().title()}!",
        )

        self.progress_container = Box(
            name="progress-bar-container",
            children=[
                Label(label="CachyNix when @Naim?"),
            ],
        )

        # Control Buttons (no text, icon only)
        def make_button(name, icon, tooltip):
            btn = Button(name=name, label=icon, tooltip_text=tooltip)
            btn.add_style_class("control-button")
            return btn

        self.logout_button = make_button("logout-button", "", "Logout")
        self.logout_button.connect("clicked", self.on_logout_click)

        self.lock_button = make_button("lock-button", "󰍹", "Lock")
        self.lock_button.connect("clicked", self.on_lock_click)

        self.reboot_button = make_button("reboot-button", "", "Reboot")
        self.reboot_button.connect("clicked", self.on_reboot_click)

        self.shutdown_button = make_button("shutdown-button", "", "Shutdown")
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

    def update_uptime_label(self):
        self.uptime_label.set_label(self.get_current_uptime())

    def on_logout_click(self, button):
        logger.info("Logout clicked")

    def on_lock_click(self, button):
        logger.info("Lock clicked")

    def on_reboot_click(self, button):
        logger.info("Reboot clicked")

    def on_shutdown_click(self, button):
        logger.info("Shutdown clicked")

    def get_current_uptime(self):
        uptime = time.time() - psutil.boot_time()
        days, rem = divmod(uptime, 86400)
        hours, _ = divmod(rem, 3600)
        return f"{int(days)} {'days' if days != 1 else 'day'}, {int(hours)} {'hours' if hours != 1 else 'hour'}"


if __name__ == "__main__":
    panel = SidePanel()
    app = Application("side-panel", panel)
    app.set_stylesheet_from_file(get_relative_path("./style.css"))
    app.run()
