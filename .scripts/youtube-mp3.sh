#!/bin/bash

youtube-dl --literal --extract-audio --audio-format=mp3 "$1"
