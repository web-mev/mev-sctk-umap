workflow SctkUmapDimensionReduce {
    
    # An integer matrix of counts
    File raw_counts

    # The number of PCA dimensions to use PRIOR to running the umap alg.
    Int pca_dim

    call runUmap {
        input:
            raw_counts = raw_counts,
            pca_dim = pca_dim
    }

    output {
        File umap_output = runUmap.fout
    }
}

task runUmap {
    File raw_counts
    Int pca_dim

    String output_name = 'umap_projection.tsv'

    Int disk_size = 100

    command {
        Rscript /opt/software/sctk_dimreduce.R ${raw_counts} ${pca_dim} ${output_name}
    }

    output {
        File fout = "${output_name}"
    }

    runtime {
        docker: "blawney/mev-sctk-umap-dimension-reduce"
        cpu: 4
        memory: "16 G"
        disks: "local-disk " + disk_size + " HDD"
        preemptible: 0
    }
}
