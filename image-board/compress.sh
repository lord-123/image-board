#!/bin/bash
convert images/$1[0] -compress JPEG -quality 10 -resize $3 images/$2