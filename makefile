#make cross validation folds and output in feature matrix, arff and libsvm (imputed and coded)
folds train_0.fm : data.fm
	time nfold -fm data.fm -target B:CLIN:Preterm:NB:::: -writeall -impute

BenchCFHet : train_0.fm
	for number in {0..2} ; do \
	    growforest -train train_$${number}.fm -target B:CLIN:Preterm:NB::::  -test test_$${number}.fm > CFHet_fold_$${number}.out; \
	done 

BenchCFNum : train_0.fm
	for number in {0..2} ; do \
	    growforest -train train_$${number}.fm.libsvm -target 0  -test test_$${number}.fm.libsvm > CFNum_fold_$${number}.out; \
	done 

BenchSKL : train_0.fm
	for number in {0..2} ; do \
	    python sklrf.py train_$${number}.fm.libsvm test_$${number}.fm.libsvm > SKL_fold_$${number}.out; \
	done 

BenchRRF : train_0.fm
	for number in {0..2} ; do \
		R CMD BATCH --no-save --no-restore '--args train_$${number}.fm.libsvm test_$${number}.fm.libsvm B:CLIN:Preterm:NB::::' Rrf.r Rrf_fold_$${number}.out; \
	done

make all : BenchCFNum BenchCFHet BenchSKL

clean :
	rm train_*.fm*
	rm test_*.fm*
