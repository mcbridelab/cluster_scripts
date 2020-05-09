#!/usr/bin/env python
#outputs a simple vcf-like( NOT UP TO SPEC) text file of differences between different consensus references with same coordinate system
#USAGE python compare_ref.py ref1.fa ref2.fa

import sys
from Bio import SeqIO

ref1 = sys.argv[1]
ref2 = sys.argv[2]
out = sys.stdout
err = sys.stderr

ref_dict1 = SeqIO.to_dict(SeqIO.parse(ref1, "fasta"))

for record in SeqIO.parse(ref2, "fasta"):
    refrec = ref_dict1[record.id]
    for base in range(0,len(record.seq)):
        if record.seq[base].upper() != refrec.seq[base].upper():
            out.write(record.id+"\t"+str(base+1)+"\t"+refrec.seq[base].upper()+"\t"+record.seq[base].upper()+"\n")
