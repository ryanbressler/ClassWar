#data = 2014_07_16_clinical_rel_df4_all_hilevel.fm
data = 2013_10_30_genomic_update_all_hilevel.fm

#used by deidentifiacton code
idtarget = B:CLIN:Preterm:NB::::

#used by cloudforest, R and for libsvm output. 
#scikit learn just grabs the target in the libsvm 
#target = C:0
target = C:0

#only used by rf-ace
mtry = 15


#grab feature sets
gene.idd.fm : $(data)
	head -n 1 $(data) > gene.idd.fm
	grep $(idtarget) $(data) >> gene.idd.fm
	grep :HHRF: $(data) >> gene.idd.fm

clin.idd.fm : $(data)
	head -n 1 $(data) > clin.idd.fm
	grep :CLIN: $(data) >> clin.idd.fm

	
#deidentify and put target in position 0
gene.fm : gene.idd.fm 
	toafm -anontarget $(idtarget) -data gene.idd.fm  -out gene.fm -blacklist Preterm+R.txt

clin.fm : clin.idd.fm
	toafm -anontarget $(idtarget) -data clin.idd.fm  -out clin.fm -blacklist Preterm+R.txt

gene_folds : gene.fm
	mkdir gene_folds  
	cd gene_folds ; time nfold -fm ../gene.fm -target $(target) -writeall -impute -maxcats 32 -folds 10
	

clin_folds : clin.fm
	mkdir clin_folds  
	cd clin_folds ;time nfold -fm ../clin.fm -target $(target) -writeall -impute -maxcats 32 -folds 10
	
#run cf hetrogenous benchmarks on both folds
BenchCFHet : clin_folds
	for number in {0..9} ; do \
		for dir in *_folds ; do \
	    	cd $${dir} ; growforest -train train_$${number}.fm -target $(target)  -test test_$${number}.fm -nTrees 500  > CFHet_fold_$${number}.out; cd ..;\
		done \
	done 

#run cf num benchmakrs on both folds
BenchCFNum : clin_folds
	for number in {0..9} ; do \
		for dir in *_folds ; do \
	    	cd $${dir} ; growforest -train train_$${number}.fm.libsvm -target 0  -test test_$${number}.fm.libsvm -nTrees 500 > CFNum_fold_$${number}.out; cd ..; \
		done \
	done 

#run scikit learn benchmakrs on all folds
BenchSKL : clin_folds
	for number in {0..9} ; do \
		for dir in *_folds ; do \
	    	cd $${dir} ; python ../sklrf.py train_$${number}.fm.libsvm test_$${number}.fm.libsvm > SKL_fold_$${number}.out; cd ..; \
	    done \
	done 

#run rf-ace benchmarks on both folds
BenchRFACE : clin_folds
	for number in {0..9} ; do \
		for dir in *_folds ; do \
			cd $${dir} ; time rf-ace --trainData train_$${number}.fm --target "$(target)" --mTry $(mtry) --nTrees 500 --saveForest train_$${number}.fm.sf  > RFACE_fold_$${number}.out; cd ..; \
			cd $${dir} ; applyforest -fm test_$${number}.fm -rfpred train_$${number}.fm.sf >> RFACE_fold_$${number}.out; cd ..; \
		done \
	done

#run rrf benchmarks on boht folds
BenchRRF : clin_folds
	for number in {0..9} ; do \
		for dir in *_folds ; do \
			cd $${dir} ; R CMD BATCH --no-save --no-restore "--args train_$${number}.fm.arff test_$${number}.fm.arff $(target)" ../Rrf.r Rrf_fold_$${number}.out; cd ..; \
		done \
	done

#run parraele rrf benchmarks on both folds
BenchPRRF : clin_folds
	for number in {0..9} ; do \
		for dir in *_folds ; do \
			cd $${dir} ; R CMD BATCH --no-save --no-restore "--args train_$${number}.fm.arff test_$${number}.fm.arff $(target)" ../parRrf.r PRrf_fold_$${number}.out; cd ..; \
		done \
	done



#parse and output results
parse : 
	for dir in *_folds ; do \
		echo $${dir} ;\
		cd $${dir} ; python ../parse_results.py ; cd ..; \
	done \

	

clin : BenchCFNum BenchCFHet BenchSKL BenchRFACE BenchRRF parse

all : gene_folds clin

clean :
	rm -r clin*
	rm -r gene*
	


