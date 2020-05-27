//Parameters for the coalescence simulation program : fastsimcoal.exe
3 samples to simulate :
//Population effective sizes (number of genes)
NBKK
NNGO
NBTT
//Haploid samples sizes 
32
28
22
//Growth rates: negative growth implies population expansion
0
0
0
//Number of migration matrices : 0 implies no migration between demes
3
//Migration matrix 0
0	M01	0
M10	0	M12
0	M21	0
//Migration matrix 1
0	0	0
0	0	M12
0	M21	0
//Migration matrix 2
0	0	0
0	0	0
0	0	0
//historical event: time, source, sink, migrants, new deme size, new growth rate, migration matrix index
3 historical event
TGROW 0 0 0 R3 0 0
TINVADE 0 1 1 R1 0 1
TDIV 1 2 1 R2 0 2
//Number of independent loci [chromosome] 
1 0
//Per chromosome: Number of contiguous linkage Block: a block is a set of contiguous loci
1
//per Block:data type, number of loci, per generation recombination and mutation rates and optional parameters
FREQ 1 0 2.8e-9 OUTEXP
