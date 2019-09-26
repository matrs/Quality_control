from pathlib import Path

configfile: "config.yaml"

def get_read(wildcard):
    path = Path(config["file_path"])
    fastq = "{}.fastq.gz".format(wildcard)
    #print("fastq file", fastq)
    return str(path.joinpath(fastq))
