#!/bin/bash
##    ---------------  作业调度系统相关的配置 -------------------
#SBATCH -p gpu			## 运行在GPU节点，无需改动
#SBATCH -J AF2__JXT		## 任务名称，可自定义
#SBATCH -n 20			## 计算所用CPU核心数，可自定义
#SBATCH --gpus 1		## 指定所需的GPU卡数
#SBATCH -o %J.out.txt		## 标准输出，文件名称可自定义
#SBATCH -e %J.err.txt		## 标准错误输出，文件名称可自定义

##    ---------------  数据库和输入输出相关的配置 -------------------
export DOWNLOAD_DIR=/ssd1/database/alphafold2	## 数据库的位置
export OUTPUT_DIR=$(pwd)			## 输出目录，默认是当前目录可自定义
export INPUT_DIR=$(pwd)				## 输入目录，默认当前目录
mkdir -p $OUTPUT_DIR
for fasta_file in ${INPUT_DIR}/*.fasta;
do
	
##    -----------  alphafold的运行参数，根据需要修改即可 -------------------
time singularity exec --nv -B ${DOWNLOAD_DIR}:${DOWNLOAD_DIR} -B ${OUTPUT_DIR}:${OUTPUT_DIR} \
	-B  ${INPUT_DIR}:${INPUT_DIR} \
	/share/software/alphafold2/alphafold-2.3.2.rtx4090/alphafold-2.3.2-rtx4090.sh  python /app/alphafold/run_alphafold.py \
	--use_gpu_relax=true \
	--data_dir=$DOWNLOAD_DIR \
	--uniref90_database_path=$DOWNLOAD_DIR/uniref90/uniref90.fasta \
	--mgnify_database_path=$DOWNLOAD_DIR/mgnify/mgy_clusters_2022_05.fa \
        --pdb_seqres_database_path=$DOWNLOAD_DIR/pdb_seqres/pdb_seqres.txt \
	--bfd_database_path=$DOWNLOAD_DIR/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt \
	--uniref30_database_path=$DOWNLOAD_DIR/uniref30/UniRef30_2021_03 \
        --uniprot_database_path=$DOWNLOAD_DIR/uniprot/uniprot.fasta \
	--template_mmcif_dir=$DOWNLOAD_DIR/pdb_mmcif/mmcif_files \
	--obsolete_pdbs_path=$DOWNLOAD_DIR/pdb_mmcif/obsolete.dat \
	--model_preset=multimer \
	--max_template_date=2020-05-14 \
	--db_preset=full_dbs \
	--output_dir=${OUTPUT_DIR} \
	--fasta_paths=${fasta_file} \
        --models_to_relax=best \
        --use_precomputed_msas=True \
        --num_multimer_predictions_per_model=1 \
        --calc_extra_ptm
done