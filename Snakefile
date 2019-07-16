include: "rules/qc.smk"
    
rule all:
    input:
        "qc/multiqc_report.html"
