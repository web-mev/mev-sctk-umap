# mev-sctk-umap

This repository contains a WDL-format Cromwell-compatible workflow for executing a UMAP projection (https://umap-learn.readthedocs.io/en/latest/) of single-cell RNA-seq data as provided through the Single-Cell Toolkit (https://github.com/compbiomed/singleCellTK).

To use, simply fill in the the `inputs.json` with the path to the single-cell counts file and the number of PCA-dimensions (for pre-processing prior to UMAP). Then submit to a Cromwell runner. 

Alternatively, you can pull the docker image (https://github.com/web-mev/mev-sctk-umap/pkgs/container/mev-sctk-umap), start the container, and run: 

```
Rscript /opt/software/sctk_dimreduce.R \
    <path to raw counts tab-delimited file> \
    <number of PCA dimensions, as integer> \
    <path to output filename>
```