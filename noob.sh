#!/bin/bash

command_exists() {
    command -v "$1" &>/dev/null
}

if command_exists g++; then
    echo "INstalled"
else
    echo "BHAI MARO MUJHE" 
fi
