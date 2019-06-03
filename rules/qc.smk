rule fastq_screen:
    input:
        get_fastqs
    output:
        html="qc/fastq_screen/{sample}-{unit}_screen.html",
        png="qc/fastq_screen/{sample}-{unit}_screen.png",
        txt="qc/fastq_screen/{sample}-{unit}_screen.txt"
    log:
        "logs/fastq_screen/{sample}-{unit}.log"
    params:
        fastq_screen_config="fastq_screen.conf", #tsv also works
        subset=int(1e6),
        aligner='bowtie2',
        extra=""
    threads: 4
    priority: 2
    wrapper:
        "file:wrappers/fastq_screen/"
    
#rule fastqc:
#    input:
#        get_fastqs
#    output:
#        html="qc/fastqc/{sample}-{unit}.html",
#        zip="qc/fastqc/{sample}-{unit}.zip"
#    log:
#        "logs/fastqc/{sample}-{unit}.log"
#    priority: 1
#    wrapper:
#    #    "0.35.0/bio/fastqc"
#        "file:/rhome/jluis/bigdata/Tutorials/rna-seq_yeast/Mulla_elife_2017/snakemake-wrappers//bio/fastqc"
    #shell:
    #"fastqc -t 6  {input} -o fastqc --quiet"

rule multiqc:
    input:
        "qc/fastqc/",
        expand("qc/fastq_screen/{unit.sample}-{unit.unit}_screen.txt", unit=units.itertuples())
    output:
        "qc/multiqc_report.html"
    log:
        "logs/multiqc.log"
    params:
        #config["params"]["multiqc"]
    wrapper:
           "file:../rna-seq-star-deseq2/snakemake-wrappers/bio/multiqc"
    # shell:
    #    "multiqc -n mutiqc_report.html --title 'fastq screen and fastqc' --comment 'Quality control' --force qc/fastq_screen qc/fastqc"
