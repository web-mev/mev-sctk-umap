suppressMessages(suppressWarnings(library(singleCellTK)))

# args from command line:
args <- commandArgs(TRUE)
RAW_COUNT_MATRIX <- args[1]
PCA_DIM <- as.integer(args[2]) # how many PCA dimensions to use in the 'pre-reduction' prior to umap
OUTPUT_UMAP_BASE <- args[3]

# Import counts as a vanilla dataframe
counts <- read.table(
    file = RAW_COUNT_MATRIX,
    sep = "\t",
    row.names = 1,
    header=T,
    check.names = FALSE
)

# above, we set check.names=F to prevent the mangling of the sample names.
# Now, we stash those original sample names and run make.names, so that any downstream
# functions, etc. don't run into trouble. In the end, we convert back to the original names
orig_cols = colnames(counts)
new_colnames = make.names(orig_cols)
colnames(counts) = new_colnames

colname_mapping = data.frame(
    orig_names = orig_cols,
    row.names=new_colnames,
    stringsAsFactors=F
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
sce <- runUMAP(
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
m = merge(df.umap,colname_mapping,by.x=0, by.y=0)
rownames(m) = m[,'orig_names']
m = m[,c('UMAP1','UMAP2')]

# transpose for easier frontend handling
m <- t(m)
write.table(m, OUTPUT_UMAP_BASE, sep='\t', quote=F)
