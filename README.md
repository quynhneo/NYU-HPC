# NYU HPC 
Handy scripts and other useful tricks to run jobs on high performance computing Greene cluster at New York University (but should be applicable elsewhere)

**Singularity**

Singularity is similar to Docker container, allows OS level virtualization.
To see example of using Singularity, installing conda env in a container, submit the job with slurm, see [singularity.md](https://github.com/quynhneo/NYU-HPC/blob/main/singularity.md)

**How to have frequent output from SLURM?**

If you are running a job on slurm, the output will be saved to a file e.g `jobid.out` but you don't see any stdout until the job is done.
To fix this, modify print statement in python from `print(something)` to `print(something,flush=True)`
reference: see a comment in https://stackoverflow.com/questions/25170763/how-to-change-how-frequently-slurm-updates-the-output-file-stdout

**Squash**

Squash file system allows compressing a folder containing a large number of file into a .sqf file, which then can be mounted like a partition (think of a DVD).
This is useful for decreasing inode number, and data is read only. 

Basic usage:
1. Create a squash file from folder:
```
mksquashfs myfolder myfolder.sqf -keep-as-directory
```
2. Mounting the file on an Ubuntu Container and run shell:
```
singularity exec --overlay myfolder.sqf:ro /scratch/work/public/singularity/ubuntu-20.04.1.sif /bin/bash
```
myfolder is now avaiable as a mounted volume at `/myfolder`

For `squashing` a lot of folders, step 1 could be tedious so I wrote a script to loop through folders [squashing.sh](https://github.com/quynhneo/NYU-HPC/blob/main/squashing.sh)
