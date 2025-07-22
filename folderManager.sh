#!/bin/bash

# for documents
cd /home/$(whoami)/Downloads
for ext in pdf docx odt; do
    mv *."$ext" ~/Downloads/documents/ 2>/dev/null
done

# for archives
mv -n ~/Downloads/*.iso ~/Downloads/iso/ 2> /dev/null
mv -n ~/Downloads/*.tar* ~/Downloads/extraction/ 2> /dev/null

# for images and gifs
for ext in jpg png gif; do
    mv -n ~/Downloads/*."$ext" ~/Downloads/images/ 2>/dev/null
done

echo "Downloads organized at $(date)" >> ~/Downloads/organized.log

