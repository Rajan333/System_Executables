#!/bin/bash

set -e

youtube-dl --extract-audio --audio-format mp3 $1 


