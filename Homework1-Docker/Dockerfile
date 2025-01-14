FROM risserlin/bcb420-base-image:winter2025-arm64

RUN R -e "install.packages(c('BiocManager'))" && \
    R -e "BiocManager::install(c('DESeq2', 'pheatmap', 'enrichplot'))"