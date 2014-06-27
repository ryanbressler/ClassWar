data = data.fm
target = B:CLIN:Preterm:NB::::

#make cross validation folds and output in feature matrix, arff and libsvm (imputed and coded)
folds train_0.fm : $(data)
	time nfold -fm $(data) -target $(target) -writeall -impute -maxcats 32

BenchCFHet : train_0.fm
	for number in {0..4} ; do \
	    growforest -train train_$${number}.fm -target $(target)  -test test_$${number}.fm > CFHet_fold_$${number}.out; \
	done 

BenchCFNum : train_0.fm
	for number in {0..4} ; do \
	    growforest -train train_$${number}.fm.libsvm -target 0  -test test_$${number}.fm.libsvm > CFNum_fold_$${number}.out; \
	done 

BenchSKL : train_0.fm
	for number in {0..4} ; do \
	    python sklrf.py train_$${number}.fm.libsvm test_$${number}.fm.libsvm > SKL_fold_$${number}.out; \
	done 

BenchRRF : train_0.fm
	for number in {0..4} ; do \
		R CMD BATCH --no-save --no-restore "--args train_$${number}.fm.arff test_$${number}.fm.arff $(target)" Rrf.r Rrf_fold_$${number}.out; \
	done

parse : CFHet_fold_0.out CFNum_fold_0.out Rrf_fold_0.out SKL_fold_0.out
	python parse_results.py

all : BenchCFNum BenchCFHet BenchSKL BenchRRF parse

clean :
	rm train_*.fm*
	rm test_*.fm*
