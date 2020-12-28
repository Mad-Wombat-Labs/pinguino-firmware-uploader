#!/usr/bin/python3

"""
Basic gui for uploader script.

Written so I can give people something they might be able to cope with!
"""

from multiprocessing import Process
from tkinter import StringVar, Tk
from tkinter.filedialog import askopenfile
from tkinter.ttk import Button, Label, OptionMenu, Progressbar
import multiprocessing
import boards
import uploader.uploader

hexfile = None
board = None


def load_firmware():
    """Load firmware to install."""
    global hexfile
    hexfile = askopenfile(
        filetypes=[("HEX file", "*.hex")], defaultextension=".hex"
    ).name


count = 0
upload_timeout = False


def poller():
    global progress_bar, upload_process, count, upload_timeout, popup
    if count > 50:
        upload_process.terminate()  # timeout
        progress_bar.stop()
        count = 0
        upload_timeout = True
        popup.quit()
    elif upload_process.is_alive():  # process is still running
        count += 1
        progress_bar.after(100, poller)  # continue polling
    else:
        progress_bar.stop()  # process ended; stop progress bar
        popup.quit()


def popup_notification(msg, title):
    """Basic notification."""
    popup_window = Tk()
    popup_window.wm_title(title)
    Label(popup_window, text=msg).pack(side="top", fill="x", pady=10)
    q_button = Button(popup_window, text="Okay", command=popup_window.quit)
    q_button.pack()
    popup_window.mainloop()  # blocking
    return popup_window


def upload_firmware():
    """Upload firmware to device."""
    global hexfile, selected_board, upload_process, progress_bar, popup, upload_timeout

    upload_timeout = False

    board = board_list[selected_board.get()]

    up = uploader.uploader.Uploader()
    up.configure_uploader(hexfile, board)
    print(up)   
    
    popup = Tk()
    popup.wm_title("Uploading")
    progress_bar = Progressbar(popup, mode="indeterminate")
    progress_bar.pack()
    progress_bar.start()

    progress_bar.after(100, poller)

    upload_process = Process(target=up.upload_hex)
    upload_process.start()
    popup.mainloop()
    if upload_process.exitcode:
        popup_notification("Uploader error!", "Error!").destroy()
    if upload_timeout:
        popup_notification("Upload timed out", "Error!").destroy()
    popup.destroy()


if __name__ == "__main__":
    multiprocessing.freeze_support()
    root = Tk()
    root.title("Firmware Updater")

    selected_board = StringVar()
    board_list = {board.name: board for board in boards.boardlist}

    board_menu = OptionMenu(root, selected_board, "Pinguino 4550", *board_list.keys())
    board_menu.pack()

    load_button = Button(root, text="Load firmware", command=load_firmware)
    load_button.pack()

    upload_button = Button(root, text="Upload firmware", command=upload_firmware)
    upload_button.pack()

    root.mainloop()
