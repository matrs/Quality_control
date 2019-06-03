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
          "0.35.0/bio/multiqc" 
