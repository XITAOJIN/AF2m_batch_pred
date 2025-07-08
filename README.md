# AF2m_batch_pred & statiscs
Batch prediction and statistics of AF2m.

As it is called, these two scripts are used to batch prediction with AlphaFold2-multimer Locally. 

Note: The premise is that you should install AF2 on your Linux server, and I strongly recommend you exlpoiting Slurm tool to assign your GPUs and better to manage your tasks.

How to use the scripts:

So easily! First, you should prepare your protein(s)-protein(s) or protein(s)-peptide(s) complex files in fasta format, then run AF2m_batch_pred.sh on your local server:

sbatch AF2m_batch_pred.sh

Finally, you will obtain many output folder at the present DIR and every output folder will include 5 prediction models(from model 0 to 4) and their scores. You can use PyMol to show them.

To summarize every top score of all output folders, you can run AF2m_batch_statistics.sh:

sbatch AF2m_batch_statistics.sh

In this way, you will obtain final top scores of every fasta file.
