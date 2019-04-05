#!/usr/bin/env bash
SRC=src
BLUE='\033[0;34m'
NC='\033[0m'

cd $SRC

clean_lua() {
	echo -e "${BLUE}Deleting existing Lua files${NC}"
	find . -name '*.lua' -type f -not -path 'libs/*' -delete

	echo ""
}

build_moonscript() {
	echo -e "${BLUE}Building .moon files${NC}"
	for m in $(find . -name '*.moon' -type f)
	do
		echo "* Building $m"
		moonc $m
	done

	echo ""
}

build_aseprite() {
	echo -e "${BLUE}Building Aseprite assets${NC}"

	for a in $(find . -name '*.aseprite' -type f)
	do
		echo "* Exporting $a"
		dir=$(dirname $a)
		filename=$(basename $a | cut -f 1 -d '.')
		aseprite --batch --sheet $dir/$filename.png --data $dir/$filename.json $a
	done

	echo ""
}

build_tiled() {
	echo -e "${BLUE}Building tilemaps${NC}"

	for m in $(find . -name '*.tmx' -type f)
	do
		echo "* Exporting $m"
		dir=$(dirname $m)
		filename=$(basename $m | cut -f 1 -d '.') 
		tiled --export-map $m $dir/$filename.lua 
	done

	echo ""
}

build() {
	clean_lua
	build_moonscript
	#build_aseprite
	#build_tiled
}

run() {
	echo -e "${BLUE}Running LOVE${NC}"
	love .
}

ship() {
	echo -e "${BLUE}Building release version${NC}"

	rm -r ../bin
	rm -r ../ship

	echo -e "* Copying src to bin"
	mkdir -p ../bin
	mkdir -p ../ship

	SHIP=$(readlink -f ../ship)
	BIN=$(readlink -f ../bin)

	cp -a . $BIN

	echo -e "* Cleaning up development-only files"
	find ../bin -name '*.moon' -type f -delete

	echo -e "* Building .love"
	cd $BIN

	zip -r $SHIP/out.love .

	echo -e "* Downloading LOVE for Windows"
	tmpfile=$(mktemp /tmp/lovebuild-XXXXXX)
	extracttmpfile=$(mktemp -d /tmp/lovebuild-XXXXXX)

	wget -O $tmpfile https://bitbucket.org/rude/love/downloads/love-11.2-win64.zip

	unzip $tmpfile -d $extracttmpfile

	lovepath="${extracttmpfile}/love-11.2.0-win64"
	cat $SHIP/out.love $lovepath/love.exe > $lovepath/game.exe

	mkdir $SHIP/win64
	cp $lovepath/* $SHIP/win64

	rm $tmpfile
	rm $extracttmpfile -r

	cd - > /dev/null
}

if [ "$1" == "run" ]; then
	build;
	run;
elif [ "$1" == "build" ]; then
	build;
elif [ "$1" == "ship" ]; then
	build;
	ship;
else
	echo "Supply an argument. Valid arguments: 'build', 'run', 'ship'"
fi

cd - > /dev/null
