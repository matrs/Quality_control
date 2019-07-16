from pathlib import Path
configfile: "config.yaml"

path = Path(config["file_path"])
wildcards, = glob_wildcards(path.joinpath("{sample}.fastq.gz"))
print("wildcards", wildcards)

rule fastq_screen:
    input:
        "../SRP073391/reads/paired-reads/{sample}.fastq.gz"
    output:
        html="qc/fastq_screen/{sample}_screen.html",
        png="qc/fastq_screen/{sample}_screen.png",
        txt="qc/fastq_screen/{sample}_screen.txt"
    log:
        "logs/fastq_screen/{sample}.log"
    params:
        #wrapper makes this param name mandatory, can't be changed
        fastq_screen_config=config["fastq_screen"]["conf"], #tsv also works
        subset=int(1e6),
        aligner='bowtie2',
        extra=""
    threads: config["fastq_screen"]["threads"]
    wrapper:
        "file:wrappers/fastq_screen/"
    
rule fastqc:
    input:
       "../SRP073391/reads/paired-reads/{sample}.fastq.gz"
    output:
        html="qc/fastqc/{sample}_fastqc.html",
        zip="qc/fastqc/{sample}_fastqc.zip"
    log:
       "logs/fastqc/{sample}.log"
    wrapper:
       "0.35.0/bio/fastqc"

rule multiqc:
    input:
        expand(["qc/fastq_screen/{sample}_screen.txt", "qc/fastqc/{sample}_fastqc.zip"], sample=wildcards)
    output:
        "qc/multiqc_report.html"
    log:
        "logs/multiqc.log"
    params:
        config["params"]["multiqc"]
    wrapper:
        "0.35.0/bio/multiqc" 
