import glob

sums = {}

for fn in glob.glob('*.out'):
	vs = fn.split(".")[0].split("_")
	key = "_".join(vs[:-2])

	time = 0.0
	error = 0.0

	fo = open(fn)
	for line in fo:
		if line.startswith("Total training time (seconds):"):
			time = float(line.split()[-1])
		if line.startswith("Error:"):
			error = float(line.split()[-1])

	if key not in sums:
		sums[key]=[1,time,error]
	else:
		sums[key][0]+=1
		sums[key][1]+=time
		sums[key][2]+=error
print "Implementation Time(s) Error"
for k in sums:
	print "\t".join([str(v) for v in [k, sums[k][1]/sums[k][0], sums[k][2]/sums[k][0]]])




