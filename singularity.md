# Instruction for using Singularity on HPC
This guide is especially applicable for the Greene HPC Cluster of New York University, but should be generally applicable for HPC clusters.
The prerequisites are:
- Having access to a cluster 
- The cluster uses Singularity container 
- Having singularity images and overlay files prebuilt 

## To setup conda environment with Sigularity and overlay images
in a log-in node:
```
$cd project_folder
```

Copy the proper gzipped overlay images from `/scratch/work/public/overlay-fs-ext3/`. There are many overlay images to choose from, different by capacity and number of files they can contain. For example, `overlay-5GB-200K.ext3.gz` is good enough for most conda environments.
```
$cp -rp /scratch/work/public/overlay-fs-ext3/overlay-5GB-200K.ext3.gz .
$gunzip overlay-5GB-200K.ext3.gz
```
Choose a proper singularity image from `/scratch/work/public/singularity/`. The image names suggest what have been prebuilt into it, and version of the OS. For example, for CUDA on ubuntu18.04: `/scratch/work/public/singularity/cuda11.0-cudnn8-devel-ubuntu18.04.sif`

Launch container interactively: 

```
$singularity exec --overlay overlay-5GB-200K.ext3 /scratch/work/public/singularity/cuda11.0-cudnn8-devel-ubuntu18.04.sif /bin/bash
```
Now you are inside the container - a fresh system and you can install anything you want (notice the change of the prompt). You shouldn't use `module load` now, as that's for the host system. It's better to install your package inside Singularity container, either manually or using package managers such as conda or pip.
Let's go through an example with conda. First, install miniconda into /ext3/miniconda3:
```
Singularity> wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
Singularity> sh Miniconda3-latest-Linux-x86_64.sh -b -p /ext3/miniconda3
Singularity> export PATH=/ext3/miniconda3/bin:$PATH
Singularity> conda update -n base conda -y
```
create a wrapper script /ext3/env.sh: 
```
#!/bin/bash
source /ext3/miniconda3/etc/profile.d/conda.sh
export PATH=/ext3/miniconda3/bin:$PATH
```
Run the wrapper:
```
Singularity> source /ext3/env.sh
```
Sanity checks if miniconda is installed properly:
```
Singularity> which python
/ext3/miniconda3/bin/python
Singularity> which conda
/ext3/miniconda3/bin/conda
Singularity> python --version
Python 3.8.5
```

Now you install packages into this base environment either with pip or conda as usual.
For example, using conda to create a virtual env, and install packaged listed in `requirements.txt`:
```
Singularity> conda create --name myenv --file requirements.txt 
```
Now everything is ready. Conda environment named `myenv` has been created **inside** the singularity container, and all packages listed in `requirements.txt` have been installed. This ensure that your inode quota is not consumed, and the environment is exactly reproducible. You can change the overlay file name to something else to reflect its installed packages.
To run `myscript.py`, there are now two options: interactive running (good for testing, debugging, short jobs), and batch job good for real and longer jobs. 
## Interactive mode
From a log in node, request a computing node with gpu:
```
$srun --cpus-per-task=20 --gres=gpu:1 --nodes 1 --mem=50GB --time=7-00:00:00 --pty /bin/bash
```
In the computing node:
```
$cd project_folder
$singularity exec --overlay overlay-5GB-200K.ext3 /scratch/work/public/singularity/cuda10.1-cudnn7-devel-ubuntu18.04.sif /bin/bash
Singularity> source /ext3/env.sh
Singularity> conda activate myenv
Singularity> python myscript.py
```
## Batch mode
Make a script such as `slurm.s` below and modify directory as needed 
```
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --gres=gpu:1
#SBATCH --time=24:00:00
#SBATCH --mem=50GB
#SBATCH --job-name=detm
#SBATCH --mail-type=END
#SBATCH --mail-user=your_email_address
#SBATCH --output=slurm_%j.out

cd /scratch/$USER/project_folder
overlay_ext3=/scratch/$USER/project_folder/overlay-5GB-200K.ext3
singularity \
exec --nv --overlay $overlay_ext3 \
/scratch/work/public/singularity/cuda11.0-cudnn8-devel-ubuntu18.04.sif /bin/bash \
-c "source /ext3/env.sh; \
conda activate project_env; \
python project_script.py"
```
to submit, from a log in node:
```
$sbatch slurm.s
```
check the status of the job, and job ID:
```
$squeue -u yourusername
```
check the stdout result:
```
$cat slurm_jobid.out
```

## Acknowledgement
Thanks NYU HPC team for support.
