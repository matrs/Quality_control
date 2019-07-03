#from snakemake.utils import validate
import pandas as pd

# this container defines the underlying OS for each job when using the workflow
# with --use-conda --use-singularity
#singularity: "docker://continuumio/miniconda3"

##### load config and sample sheets #####

configfile: "config.yaml"
#validate(config, schema="../schemas/config.schema.yaml")
# print(config["samples"])
samples = pd.read_csv(config["samples"], sep="\t").set_index("sample", drop=False)
samples.index.names = ["sample_id"]
#validate(samples, schema="../schemas/samples.schema.yaml")
# print("samples df:", samples, sep="\n")

units = pd.read_csv(
    config["units"], dtype=str, sep="\t").set_index(["sample", "unit"], drop=False)
#units.index.names = ["sample_id", "unit"]
units.index = units.index.set_levels(
    [i.astype(str) for i in units.index.levels])  # enforce str in index
#validate(units, schema="../schemas/units.schema.yaml")
print("units df", units,sep="\n")

def get_fastqs(wildcards):
    """Get raw FASTQ files from unit sheet."""
    # print("inside get_fastqs(), wildcards.sample, wildcards.unit", wildcards.sample, wildcards.unit,end='\n\n')
    return units.loc[(wildcards.sample, wildcards.unit), ["fq1", "fq2"]].dropna()
