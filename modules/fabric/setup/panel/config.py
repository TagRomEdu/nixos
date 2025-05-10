import os
import time
import json
import subprocess
import psutil
import http.client
from loguru import logger
from fabric import Application
from fabric.widgets.box import Box
from fabric.widgets.label import Label
from fabric.widgets.wayland import WaylandWindow as Window
from fabric.widgets.button import Button
from fabric.widgets.scrolledwindow import ScrolledWindow
from fabric.utils import invoke_repeater, get_relative_path
from fabric.notifications import Notifications, Notification
from typing import cast
from gi.repository import GLib, Gtk
import threading


class NotificationPopup(Window):
    def __init__(self, notification: Notification, panel_open=False, **kwargs):
        super().__init__(
            layer="overlay",
            title="fabric-notification",
            anchor="top right",
            exclusivity="none",
            visible=False,
            margin_top=20,
            margin_right=320 if panel_open else 20,  # Adjust based on panel state
            width_request=300,
            height_request=100,
            **kwargs,
        )
        
        self.notification = notification
        self.timeout_id = None
        self.panel_open = panel_open
        
        title = notification.summary or "No Title"
        body = notification.body or "No Body"
        
        self.box = Box(
            orientation="v",
            name="notification-popup",
            spacing=6,
            margin=12,
        )
        
        self.title_label = Label(
            label=f"{title}",
            name="notification-title",
            halign="start",
            xalign=0,
            use_markup=True,
        )
        
        self.body_label = Label(
            label=body,
            name="notification-body",
            halign="start",
            xalign=0,
            wrap=True,
            max_width_chars=35,
        )
        
        self.box.add(self.title_label)
        self.box.add(self.body_label)
        self.add(self.box)
        
        # Close after 5 seconds
        self.timeout_id = GLib.timeout_add_seconds(5, self.close_popup)
        
        # Close when clicked
        self.connect("button-press-event", self.close_popup)
    
    def adjust_for_panel(self, panel_open):
        """Adjust position based on panel state"""
        self.panel_open = panel_open
        if panel_open:
            self.set_margin_right(320)  # Move left by panel width
        else:
            self.set_margin_right(20)   # Return to normal position

    def close_popup(self, *args):
        if self.timeout_id:
            GLib.source_remove(self.timeout_id)
            self.timeout_id = None
        self.destroy()
        return True


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

        # Weather state variables
        self._weather_cache = None
        self._weather_last_attempt = 0
        self._weather_retry_delay = 5  # Start with 5 second delay
        self._weather_last_success = 0

        self.profile_pic = Box(name="profile-pic", children=[])
        pic_path = os.path.expanduser("/home/lysec/nixos/assets/icons/nix-catppuccin.png")
        if os.path.exists(pic_path):
            self.profile_pic.set_style(f"background-image: url('file://{pic_path}')")
        else:
            logger.warning("Custom icon not found at '/home/lysec/nixos/assets/icons/nix-catppuccin.png'")

        self.os_age_label = Label(
            label=f"OS Age: {self.get_os_age()}",
            name="os-age-label",
            halign="start",
            xalign=0
        )

        # Create time label with left alignment
        self.time_label = Label(
            name="date-time",
            halign="start",
            xalign=0
        )
        self.update_time()
        invoke_repeater(1000, self.update_time)

        # Weather label with left alignment and loading state
        self.weather_label = Label(
            name="weather-label",
            halign="start",
            xalign=0,
            label="Weather: Loading..."
        )

        self.header = Box(
            name="header",
            orientation="h",
            children=[
                self.profile_pic,
                Box(
                    orientation="v",
                    children=[
                        self.time_label,
                        self.weather_label,
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
            children=[self.rebuild_label],
        )

        # Notification history box
        self.notification_history_box = Box(
            name="notification-history-box",
            orientation="v",
            spacing=6,
        )

        self.clear_button = Button(
            label="Clear",
            name="clear-notifications-button",
            tooltip_text="Clear all notifications",
            halign="end",
            margin_end=12,
            margin_start=12,
        )
        self.clear_button.connect("clicked", self.clear_all_notifications)

        self.notifications_header = Box(
            name="notifications-header",
            orientation="h",
            hexpand=True,
            children=[
                Label(label="Recent Notifications", name="notif-title"),
                Box(hexpand=True),
                self.clear_button,
            ]
        )

        self.scrolled_window = ScrolledWindow(
            min_content_size=(300, 300),
            v_scrollbar_policy="automatic",
            h_scrollbar_policy="never",
            overlay_scroll=False,
            kinetic_scroll=True,
            child=self.notification_history_box
        )

        self.notifications_service = Notifications(
            on_notification_added=self.on_notification_added
        )

        def make_button(name, icon, tooltip):
            btn = Button(name=name, label=icon, tooltip_text=tooltip)
            btn.add_style_class("control-button")
            return btn

        self.logout_button = make_button("logout-button", "", "Logout")
        self.logout_button.connect("clicked", self.on_logout_click)

        self.lock_button = make_button("lock-button", "", "Lock")
        self.lock_button.connect("clicked", self.on_lock_click)

        self.reboot_button = make_button("reboot-button", "", "Reboot")
        self.reboot_button.connect("clicked", self.on_reboot_click)

        self.shutdown_button = make_button("shutdown-button", "⏻", "Shutdown")
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
                    self.notifications_header,
                    self.scrolled_window,
                    self.control_buttons,
                ],
            ),
        )
        
        self.empty_notifications_label = Label(
            label="No notifications",
            name="empty-notif-label",
            visible=False
        )
        self.notification_history_box.add(self.empty_notifications_label)
        
        # Track active popups
        self._popups = []
        
        # Connect signals
        self.connect("show", self.on_panel_show)
        self.connect("notify::visible", self.on_visibility_changed)
        self.show_all()

    def on_visibility_changed(self, widget, *args):
        """Update popup positions when panel visibility changes"""
        for popup in self._popups:
            popup.adjust_for_panel(self.get_visible())

    def on_panel_show(self, widget):
        """Trigger weather update after panel appears"""
        if self._weather_cache:
            self.weather_label.set_label(self._weather_cache)
        
        GLib.timeout_add(500, self.update_weather)
        invoke_repeater(1800000, self.update_weather)

    def update_weather(self):
        """Threaded weather update with exponential backoff and caching"""
        now = time.time()
        
        if self._weather_cache and (now - self._weather_last_success < 1800):
            GLib.idle_add(lambda: self.weather_label.set_label(self._weather_cache))
            return True
            
        def fetch_weather():
            nonlocal now
            try:
                conn = http.client.HTTPSConnection("wttr.in", timeout=3)
                conn.request("GET", "/?format=%c+%t", headers={"User-Agent": "curl"})
                res = conn.getresponse()
                if res.status == 200:
                    weather = f"{res.read().decode('utf-8').strip()}"
                    self._weather_cache = weather
                    self._weather_last_success = time.time()
                    self._weather_retry_delay = 5
                    GLib.idle_add(lambda: self.weather_label.set_label(weather))
                else:
                    raise Exception(f"HTTP {res.status}")
            except Exception as e:
                if now - self._weather_last_attempt > 60:
                    logger.warning(f"Weather error: {e}")
                
                self._weather_retry_delay = min(self._weather_retry_delay * 2, 3600)
                
                if self._weather_cache:
                    GLib.idle_add(lambda: self.weather_label.set_label(f"{self._weather_cache} (offline)"))
                else:
                    GLib.idle_add(lambda: self.weather_label.set_label("⛅ --°C"))
            finally:
                self._weather_last_attempt = now
                try:
                    conn.close()
                except:
                    pass

        threading.Thread(target=fetch_weather, daemon=True).start()
        return self._weather_retry_delay

    def update_time(self):
        """Update the time label with current time in 24-hour format"""
        current_time = time.strftime("%H:%M:%S")
        self.time_label.set_label(current_time)
        return True

    def clear_all_notifications(self, button):
        for child in self.notification_history_box.get_children():
            if child != self.empty_notifications_label:
                self.notification_history_box.remove(child)
        self.empty_notifications_label.show()
        logger.info("All notifications cleared")

    def on_notification_added(self, service, nid):
        self.empty_notifications_label.hide()
        notif = cast(Notification, service.get_notification_from_id(nid))
        if notif:
            # Show popup notification
            popup = NotificationPopup(notif, panel_open=self.get_visible())
            self._popups.append(popup)
            popup.show_all()
            
            # Remove from tracking when closed
            popup.connect("destroy", lambda *x: self._popups.remove(popup))
            
            # Add to history
            title = notif.summary or "No Title"
            body = notif.body or "No Body"
            formatted_text = f"<b>{title}</b>\n{body}"

            notification_box = Box(
                orientation="h",
                h_align="fill",
                name="notification-box",
                margin_top=6,
                margin_bottom=6,
                margin_start=12,
                margin_end=12,
                width_request=300
            )
            
            label = Label(
                label=formatted_text,
                name="notif-item",
                halign="start",
                xalign=0,
                justify="left",
                margin_start=12,
                margin_end=12,
                wrap=True,
                wrap_mode=2,
                max_width_chars=35,
                width_chars=35,
                hexpand=True,
                vexpand=False,
                width_request=276
            )
            label.set_use_markup(True)
            label.set_line_wrap(True)
            label.set_line_wrap_mode(2)
            
            notification_box.add(label)
            self.notification_history_box.add(notification_box)
            self.notification_history_box.reorder_child(notification_box, 0)

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