#!/bin/bash
#usage submit_bcftools.sh bamlist.txt ref.fa regions.txt
#by Noah Rose

COUNTER=1
while read i; do
    echo $i
    if [[ $COUNTER -eq 1 ]]; then
        echo "#!/bin/bash" > _temp_bcftools.sbatch
        echo "#SBATCH -N 1 -c 16" >> _temp_bcftools.sbatch
        echo "#SBATCH -t 24:00:00" >> _temp_bcftools.sbatch
    fi
    echo "bcftools_call_region.sh $1 $2 $i &" >> _temp_bcftools.sbatch
    if [[ $COUNTER -eq 16 ]]; then
        echo "wait" >> _temp_bcftools.sbatch
        sbatch _temp_bcftools.sbatch
        COUNTER=0
    fi
    let COUNTER++
done < $3
if [[ $COUNTER -ne 16 ]]; then
        COUNTER=$((COUNTER-1))
	echo "wait" >> _temp_bcftools.sbatch
        sed -i "s/#SBATCH -N 1 -c .*/#SBATCH -N 1 -c $COUNTER/g" _temp_bcftools.sbatch
        sbatch _temp_bcftools.sbatch
fi
