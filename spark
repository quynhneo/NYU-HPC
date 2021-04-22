# Set up and run on NYU HPC Greene cluster


Log in to Greene and clone the project
```
git clone https://github.com/dialect-map/dialect-map-computing
```
## Setup conda environment with Singularity and overlay images
in a log-in node:
```
$cd dialect-map-computing
```

Copy the proper gzipped overlay images from `/scratch/work/public/overlay-fs-ext3`. For example, `overlay-5GB-200K.ext3.gz` is good enough for most conda environments, it has 5GB free space inside and is able to hold 200K files:
```
$cp -rp /scratch/work/public/overlay-fs-ext3/overlay-5GB-200K.ext3.gz .
$gunzip overlay-5GB-200K.ext3.gz
```
Choose a proper singularity image. To run spark, we need an OS with Java, for example:

`/scratch/work/public/singularity/ubuntu-20.04.1.sif`

To setup conda environment, first launch container interactively: 

```
$singularity exec --overlay overlay-5GB-200K.ext3 /scratch/work/public/singularity/ubuntu-20.04.1.sif /bin/bash
```
Inside the container, install miniconda into /ext3/miniconda3:
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

Now install packages into this base environment either with pip or conda.
For example, using conda to create a virtual env:
```
Singularity> conda create --name dialect_map  
Singularity> conda activate dialect_map
```
Now install python required packages using `conda install --file requirements.txt`.

What if some packages are not available through conda? You can use `pip` inside `conda` env though not recommended.
```
conda install pip 
/ext3/miniconda3/envs/myenv/bin/pip install -r requirements.txt
```
For some reason, Spark python API, pyspark installs better with conda:
`conda install -c conda-forge pyspark`

Conda environment named `dialect_map` has been installed **inside** the singularity container. This ensure that your inode quota is not consumed, and the environment is exact.

## Install Spark

Prepare directory
```
mkdir /scratch/$USER/spark_py
cd /scratch/$USER/spark_py
```
Get Spark

Go to `https://spark.apache.org/downloads.html` and choose a desired version of spark (pre-builed for Hadoop)
Click to download link - choose mirror - Copy URL, for example `https://mirrors.sonic.net/apache/spark/spark-2.4.5/spark-2.4.5-bin-hadoop2.7.tgz`

download
```
wget <url from above>
```

unzip
```
mkdir sbin
tar -xvf spark-*.tgz -C sbin --strip 1
```
create a script to start spark cluster, something like [`spark-greene-prepare.sh`](https://github.com/dialect-map/dialect-map-computing/blob/main/docs/spark-greene-prepare.sh)

To run `src/main.py`, there are now two options: interactive running (good for testing, debugging, short jobs), and batch job good for real and longer jobs. 
## Interactive mode
From a log in node, request a computing node, for example:
```
$srun --cpus-per-task=40 --nodes 1 --mem=50GB --time=1-00:00:00 --pty /bin/bash
```
In the computing node:
```
$cd dialect-map-computing
$singularity exec --overlay overlay-5GB-200K.ext3 /scratch/work/public/singularity/ubuntu-20.04.1.sif /bin/bash
Singularity> source /ext3/env.sh
Singularity> conda activate dialect_map
Singularity> cd src
```
To run with default setting of Spark
```
Singularity> python main.py [options]
```
To run with customized setting in `spark-greene-prepare.sh`:
```
Singularity> cd /scratch/$USER/spark_py
Singularity> source spark-greene-prepare.sh
Singularity> start_all
Singularity> cd ~/dialect-map-computing/src
Singularity> /scratch/$USER/spark_py/sbin/bin/spark-submit --name "spark" --master local[*] --executor-memory 1G --driver-memory 1G main.py; \
Singularity> stop_all
```

## Batch mode
Make a script such as `slurm.s` below, wrap the two methods above inside `-c "interactive commands"` and modify directory as needed 
```
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --cpus-per-task=2
#SBATCH --time=1-0
#SBATCH --mem=50GB
#SBATCH --job-name=spark
#SBATCH --mail-type=END
#SBATCH --mail-user=youremail@address.com
#SBATCH --output=slurm_%j.out

cd ~/dialect-map-computing
singularity exec --overlay \
overlay-5GB-200K.ext3 /scratch/work/public/singularity/ubuntu-20.04.1.sif /bin/bash \
-c "source /ext3/env.sh; \
conda activate dialect_map; \
cd /scratch/$USER/spark_py; \
source spark-greene-prepare.sh; \
start_all; \
cd ~/dialect-map-computing/src; \
/scratch/$USER/spark_py/sbin/bin/spark-submit --name "spark" --master local[*] --executor-memory 1G --driver-memory 1G main.py; \
stop_all"    
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
