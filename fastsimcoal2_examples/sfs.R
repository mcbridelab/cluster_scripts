args = commandArgs(trailingOnly=TRUE)

mat<-scan(args[1])
#mat<-mat[1:(length(mat)-1)]
print(args)
ncols<-2*as.numeric(args[2])+1
nrows<-2*as.numeric(args[3])+1
#necessary to round? not sure
flat<-matrix(round(mat),ncol=ncols,byrow=T)
#might need to transpose if you are doing more than two populations
#flat<-t(flat)
colnames(flat)<-paste('d0_',0:(ncols-1),sep='')
rownames(flat)<-paste('d1_',0:(nrows-1),sep='')
write.table(flat,file=args[4],quote=F,sep='\t')
