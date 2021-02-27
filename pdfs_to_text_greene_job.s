#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=48
#SBATCH --time=7-0
#SBATCH --mem=128GB
#SBATCH --job-name=pdf2txt
#SBATCH --mail-type=END
#SBATCH --mail-user=qmn203@nyu.edu
#SBATCH --output=slurm_out/s%j.out


cd /scratch/qmn203/princehome/arxiv-public-datasets_for_kaggle
singularity exec --overlay /scratch/qmn203/shared/arxiv_pdf_before_042007.sqf:ro --overlay \
overlay-5GB-200K.ext3 /scratch/work/public/singularity/ubuntu-20.04.1.sif /bin/bash \
-c "source /ext3/env.sh; \
conda activate myenv; \
python bin/fulltext.py --PLAIN_PDFS"

