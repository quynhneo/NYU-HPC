# script to squash every sub-sub directory (depth=3) of pwd, with parent='pdf', name 4 characters 
# long (matching the 'YYMM' format) into sqf files
# mksquashfs automatically use all available processors
for d in $(find . -maxdepth 3 -mindepth 3 -name '????' ) ; do  #select only folder
	echo "${d%/}" #remove trailing slash
	if [ -f "${d%/}.sqf" ]; then
		echo "the folder has been squashed. Skipping"
	else
		echo "the folder has not been squashed. Squashing..."
		#if mksquashfs $d "${d%/}.sqf" -keep-as-directory ; then 
			#echo "squashing succeeded, deleting source"
			#rm -r $d #remove this line if unwanted!!!!
		#else
			#echo "squashing failed"
		#fi
	fi
		
done
