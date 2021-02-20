# script to squash every directory in pwd into sqf files
# mksquashfs automatically use all available processors
for d in */ ; do  #select only folder
	echo "${d%/}" #remove trailing slash
	if [ -f "${d%/}.sqf" ]; then
		echo "the folder has been squashed. Skipping"
	else
		echo "the folder has not been squashed. Squashing..."
		if mksquashfs $d "${d%/}.sqf" -keep-as-directory ; then 
			echo "squashing succeeded" 
            echo "deleting source"
			#rm -r $d #remove this line if unwanted!!!!
		else
			echo "squashing failed"
		fi
	fi
		
done
