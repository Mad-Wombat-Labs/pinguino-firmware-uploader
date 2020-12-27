#!/usr/bin/python3
from argparse import ArgumentParser
from os import path

import boards
import uploader.uploader

parser = ArgumentParser()
parser.add_argument("BOARD", help="Name of board, see boards.py for list.")
parser.add_argument("HEXFILE", help="Path to hexfile to upload.")
args = parser.parse_args()

hexfile = path.expanduser(args.HEXFILE)

board = {
    "Amicus18": boards.Amicus18,
    "CHRP3": boards.CHRP3,
    "Curiosity": boards.Curiosity,
    "Emperor_460": boards.Emperor_460,
    "Emperor_795": boards.Emperor_795,
    "FreeJALduino": boards.FreeJALduino,
    "MICROCHIP_ID": boards.MICROCHIP_ID,
    "P32_ID": boards.P32_ID,
    "P8_ID": boards.P8_ID,
    "PIC32MZSTARTERKIT": boards.PIC32MZSTARTERKIT,
    "PIC32_Pinguino": boards.PIC32_Pinguino,
    "PIC32_Pinguino_220": boards.PIC32_Pinguino_220,
    "PIC32_Pinguino_Micro": boards.PIC32_Pinguino_Micro,
    "PIC32_Pinguino_OTG": boards.PIC32_Pinguino_OTG,
    "PIC32_Pinguino_T795": boards.PIC32_Pinguino_T795,
    "PICuno_Equo": boards.PICuno_Equo,
    "Pinguino13k50": boards.Pinguino13k50,
    "Pinguino1459": boards.Pinguino1459,
    "Pinguino14k50": boards.Pinguino14k50,
    "Pinguino2455": boards.Pinguino2455,
    "Pinguino2550": boards.Pinguino2550,
    "Pinguino25k50": boards.Pinguino25k50,
    "Pinguino26J50": boards.Pinguino26J50,
    "Pinguino27J53": boards.Pinguino27J53,
    "Pinguino32MX220": boards.Pinguino32MX220,
    "Pinguino32MX250": boards.Pinguino32MX250,
    "Pinguino32MX270": boards.Pinguino32MX270,
    "Pinguino32MX470": boards.Pinguino32MX470,
    "Pinguino4455": boards.Pinguino4455,
    "Pinguino4550": boards.Pinguino4550,
    "pinguino45k50": boards.Pinguino45k50,
    "Pinguino46J50": boards.Pinguino46J50,
    "Pinguino47J53A": boards.Pinguino47J53A,
    "Pinguino47J53B": boards.Pinguino47J53B,
    "UBW32_460": boards.UBW32_460,
    "UBW32_795": boards.UBW32_795,
}

up = uploader.uploader.Uploader()
up.configure_uploader(hexfile, board[args.BOARD.strip()])
up.upload_hex()
print("Successfully uploaded!")
