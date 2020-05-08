#!/usr/bin/env python
#this script flips vcf files generated using bcftools consensus reference to a different reference.
#WARNING: only works on UNPHASED biallelic SNPs, and only for GT, GL, and PL fields
#USAGE: flipVCF.py vcf reference > out.vcf
#by Noah Rose

import sys
from Bio import SeqIO

vcf = sys.argv[1]
ref = sys.argv[2]
out = sys.stdout
err = sys.stderr

err.write("setting reference alleles in "+vcf+" to reference "+ref+"\n")
ref_dict = SeqIO.to_dict(SeqIO.parse(ref, "fasta"))

v = open(vcf,"r")

for line in v:

    #skip header lines
    if line.startswith("#"):
        out.write(line)
        continue

    entry = line.strip().split("\t") 
    chrom = entry[0]
    pos = entry[1]
    ref = entry[3]
    alt = entry[4]
    fref = ref_dict[chrom][(int(pos)-1)].upper()
    debug = " ".join([chrom,pos,ref,alt,": fasta reference was",fref+"\n"])

    #just output sites where ref matches unchanged
    if ref == fref:
        out.write(line)
        continue

    #flip simple biallelic alt consensus sites
    elif alt == fref:
        err.write("flipping "+debug)

        entry[3] = alt
        entry[4] = ref

        #pull out the indexes for the fields to flip
        FMT = entry[8].split(":")
        GT = FMT.index("GT") if "GT" in FMT else None
        GL = FMT.index("GL") if "GL" in FMT else None
        PL = FMT.index("PL") if "PL" in FMT else None
        AD = FMT.index("AD") if "AD" in FMT else None

        for i in range(9,len(entry)):
            sample = entry[i].split(":")

            #reverse fields to new dosage order
            if GL is not None:
                new = ",".join(sample[GL].split(",")[::-1])
                sample[GL] = new
            if PL is not None:
                new = ",".join(sample[PL].split(",")[::-1])
                sample[PL] = new
            if AD is not None:
                new = ",".join(sample[AD].split(",")[::-1])
                sample[AD] = new

            #switch GT manually and exit if other format, since we aren't handling many situations here
            if GT is not None:
                currGT = sample[GT]
                if currGT == "0/1":
                    new = "0/1"
                elif currGT == "0/0":
                    new = "1/1"
                elif currGT == "1/1":
                    new = "0/0"
                elif currGT == "./.":
                    new = "./."
                else:
                    sys.exit("COULD NOT FLIP, EXITING"+currGT)                    
                sample[GT] = new
                entry[i] = ":".join(sample)

        #remove INFO field since we have changed things around (CAUTION NOT TO FILTER NAIVELY ON INFO AFTER USING THIS)
        entry[7]="."
        lineflip = "\t".join(entry)
        out.write(lineflip+"\n")
        continue
    #skip if neither a match nor a simple flip (not handling indels, complex variants, triallelics here)
    else:
        err.write("COULD NOT RESOLVE, SKIPPING "+debug)
        continue

v.close()
