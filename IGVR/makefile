data = IGVR.fm
target = B:CLIN:Preterm:NB::::
mtry = 15
ntrees = 500

#make cross validation folds and output in feature matrix, arff and libsvm (imputed and coded)
folds train_0.fm : $(data)
	time nfold -fm $(data) -target $(target) -writeall -impute -maxcats 32 -folds 10 -blacklist Preterm+R.txt

BenchCFHet : train_0.fm
	for number in {0..9} ; do \
	    growforest -train train_$${number}.fm -target $(target)  -test test_$${number}.fm -nTrees 500  > CFHet_fold_$${number}.out; \
	done 

BenchCFNum : train_0.fm
	for number in {0..9} ; do \
	    growforest -train train_$${number}.fm.libsvm -target 0  -test test_$${number}.fm.libsvm -nTrees 500 > CFNum_fold_$${number}.out; \
	done 

BenchSKL : train_0.fm
	for number in {0..9} ; do \
	    python sklrf.py train_$${number}.fm.libsvm test_$${number}.fm.libsvm > SKL_fold_$${number}.out; \
	done 

BenchRRF : train_0.fm
	for number in {0..9} ; do \
		R CMD BATCH --no-save --no-restore "--args train_$${number}.fm.arff test_$${number}.fm.arff $(target)" Rrf.r Rrf_fold_$${number}.out; \
	done

BenchPRRF : train_0.fm
	for number in {0..9} ; do \
		R CMD BATCH --no-save --no-restore "--args train_$${number}.fm.arff test_$${number}.fm.arff $(target)" parRrf.r PRrf_fold_$${number}.out; \
	done

BenchRFACE : train_0.fm
	for number in {0..9} ; do \
		time rf-ace --trainData train_$${number}.fm --target "$(target)" --mTry $(mtry) --nTrees $(ntrees) --saveForest train_$${number}.fm.sf  > RFACE_fold_$${number}.out; \
		applyforest -fm test_$${number}.fm -rfpred train_$${number}.fm.sf >> RFACE_fold_$${number}.out; \
	done



parse : CFHet_fold_0.out CFNum_fold_0.out SKL_fold_0.out
	python parse_results.py

all : BenchCFNum BenchCFHet BenchSKL BenchRRF BenchPRRF BenchRFACE parse

clean :
	rm *.out
	rm train_*.fm*
	rm test_*.fm*
