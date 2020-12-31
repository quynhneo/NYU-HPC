# NYU-HPC
Handy scripts to run jobs at NYU HPC clusters.

To use Singularity, see [singularity.md](https://github.com/quynhneo/NYU-HPC/blob/main/singularity.md)

## How to have frequent stdout from SLURM
If you are running a job on slurm, the output will be saved to a file e.g `jobid.out` but you don't see any stdout until the very end.
To fix this, modify print statement in python from `print(something)` to `print(something,flush=True)`
