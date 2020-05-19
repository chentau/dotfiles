#!/bin/bash

maim -s | xclip -o > $HOME/Pictures/$(date +%m:%d:%y-%T).png
