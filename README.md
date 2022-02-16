# big-little-data

 Normalized compendia of microbial gene expression.

 More detailed notes can be found: https://osf.io/64ptf/

## Installation

Load the conda environment: micro-seq-comp_wR.yml

## Usage

 1. Create a salmon transcriptome index
        salmon index -t reference-cdna.fa.gz \
                     -i dir/for/index

 2. Make a directory of files containing accession numbers
        Rscript ../run_table/run_table_dirs.R  \
                ../run_table/SraRunTable.csv ../run_table/dir_w_accessions

 3. Map all samples in the directory to the index
        # exit the batch job submission script for
        # correct index and director of accessions

        sbatch sra_to_sal.script
    Note: repeat this step until all downloads are successful!

 4. Collect salmon output (counts and TPM) and log data

        # edit quant_collect.R for correct directory and
        # gene name file

        Rscript ../shape_comp/quant_collect.R \
                /scratch/salmon/index/dir_w_accessions \
                gene_names.csv \
                output_compendium_suffix.csv

        python ../shape_comp/logs_collect.py \
               /scratch/salmon/index/dir_w_accessions


## Support

georgia.doing@jax.org

## Roadmap

Goals:

  * to go from reference and sample accessions all the way though to compendium
  * to monitor and handle download failures
  * mapping parameter tuning
  * containerize for other HPCs
  * standardize outputs on OSF to avoid re-mapping

## Contributing

## Authors

Georgia Doing (@georgiadoing)
## License

tba

## Status

development
