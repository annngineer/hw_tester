#!/bin/bash

display_help()
{
	echo
	echo "This run tcl script for making and handling Quartus Projects"
	exit 0
}


if [ "$1" == "-h" ]; then
	display_help
fi

folder=altera_prj

rm -rf $folder
mkdir $folder
cd $folder

quartus_sh -t ../make_prj.tcl
