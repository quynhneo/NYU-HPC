# NYU HPC 
Handy scripts and other useful tricks to run jobs on high performance computing Greene cluster at New York University (but should be applicable elsewhere)

**Singularity**

Singularity is similar to Docker container, allows OS level virtualization.
To see example of using Singularity, installing conda env in a container, submit the job with slurm, see [singularity.md](https://github.com/quynhneo/NYU-HPC/blob/main/singularity.md)

**How to have frequent output from SLURM?**

If you are running a job on slurm, the output will be saved to a file e.g `jobid.out` but you don't see any stdout until the job is done.
To fix this, modify print statement in python from `print(something)` to `print(something,flush=True)`
reference: see a comment in https://stackoverflow.com/questions/25170763/how-to-change-how-frequently-slurm-updates-the-output-file-stdout

