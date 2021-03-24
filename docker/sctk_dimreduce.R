suppressMessages(suppressWarnings(library(singleCellTK)))

# args from command line:
args <- commandArgs(TRUE)
RAW_COUNT_MATRIX <- args[1]
PCA_DIM <- as.integer(args[2]) # how many PCA dimensions to use in the 'pre-reduction' prior to umap
OUTPUT_UMAP_BASE <- args[3]

# Import counts as a 
counts <- read.table(
    file = RAW_COUNT_MATRIX,
    sep = "\t",
    row.names = 1
)

# Create an SCE object from the counts
sce <- SingleCellExperiment(
    assays=list(counts=counts)
)

# PCA as a pre-processing step prior to UMAP dimensionality reduction.
# Important to decorrelate the counts prior to UMAP.
# Also log normalizes the counts.
# Default to 50 PCA dims. Higher than typically needed.
# Performing UMAP (on PCA) and adding UMAP data to the SCE object
sce <- getUMAP(
    inSCE = sce, 
    useAssay = "counts", 
    reducedDimName = "UMAP",
    logNorm = TRUE,
    nNeighbors = 30, 
    nIterations = 200, 
    alpha = 1,
    minDist = 0.01,
    pca = TRUE,
    initialDims = PCA_DIM
)

# Export UMAP values to file
df.umap <- SingleCellExperiment::reducedDim(sce, "UMAP")
write.table(df.umap, OUTPUT_UMAP_BASE, sep='\t', quote=F)
