process run_umap {

    tag "UMAP"
    publishDir "${params.output_dir}/SctkUmapDimensionReduce.umap_output", mode:"copy", pattern:"${output_name}"
    container "ghcr.io/web-mev/mev-sctk-umap"
    cpus 4
    memory '16 GB'

    input:
        path raw_counts
        val pca_dim

    output:
        path "${output_name}"

    script:
        output_name = "umap_projection.tsv"
        """
        Rscript /opt/software/sctk_dimreduce.R ${raw_counts} ${pca_dim} ${output_name}
        """
}

workflow {

    run_umap(params.raw_counts, params.pca_dim)

}
