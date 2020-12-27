#!/usr/bin/python3

"""
Basic gui for uploader script.

Written so I can give people something they might be able to cope with!
"""

from tkinter import Button, OptionMenu, StringVar, Tk
from tkinter.filedialog import askopenfile

import boards

hexfile = None
board = None


def load_firmware():
    """Load firmware to install."""
    global hexfile
    hexfile = askopenfile(
        filetypes=[("HEX file", "*.hex")], defaultextension=".hex"
    ).name


def upload_firmware():
    """Upload firmware to device."""
    global hexfile, selected_board
    import uploader.uploader

    board = board_list[selected_board.get()]

    up = uploader.uploader.Uploader()
    up.configure_uploader(hexfile, board)
    up.upload_hex()


if __name__ == "__main__":
    root = Tk()
    root.title("Firmware Updater")

    selected_board = StringVar()
    selected_board.set("Pinguino 4550")
    board_list = {board.name: board for board in boards.boardlist}
    print(board_list)
    print(selected_board.get())

    board_menu = OptionMenu(root, selected_board, *board_list.keys())
    board_menu.pack()

    load_button = Button(root, text="Load firmware", command=load_firmware)
    load_button.pack()

    upload_button = Button(root, text="Upload firmware", command=upload_firmware)
    upload_button.pack()

    root.mainloop()
