#!/bin/bash
#SBATCH -t 24:00:00 -N 1 -c 1
#Usage: sbatch bcftools_call_region.sh bamlist.txt reference.fa chr:start-end
#
#Meta-usage: while read region; do sbatch bcftools_call_region.sh bamlist.txt reference.fa $region ; done < regions.txt
#Or, to reduce node fragmentation: bash submit_bcftools.sh bamlist.txt reference.fa regions.txt
#
#Use bcftools concat --naive to combine multiple regions generated from this script
#
#by Noah Rose

echo $1
echo $2
echo $3

# Subset bams onto local node -- this speeds up reading from large numbers (hundreds or thousands) of samples
> /tmp/$3_bamlist.txt 

while read i; do 
samtools view -bq 10 $i $3 > /tmp/_tmp_$3_$i
samtools index /tmp/_tmp_$3_$i
echo "/tmp/_tmp_$3_$i" >> /tmp/$3_bamlist.txt  
echo $3_$i
done < $1

# This chain of piped commands calls biallelic SNPs in a given region
# The first command says get generate genotype likelihoods at variable sites, tracking alternate and reference read counts, skipping indels, in a specific region
# The second command says to call genotypes, including phred-scaled genotype quality estimates
# The third command says to only output biallelic snps into a compressed vcf file
bcftools mpileup -f $2 -b /tmp/$3_bamlist.txt -r $3 -Ou -I -a AD,DP,INFO/AD | bcftools call -f gq -vmO u | bcftools view -M2 -m2 -v snps -O z  > $(echo $3 | sed 's/:/-/g').vcf.gz

