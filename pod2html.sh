#!/bin/sh

files=$(ls pod/*/*.pod)
pod2html=/Users/thiago/perl5/perlbrew/build/perl-5.12.1/pod/pod2html
if [ ! -f $podhtml ] ; then
	pod2html=/usr/bin/pod2html
fi

#$pod2html --recurse --podroot=$poddir --podpath=00-introducao --htmlroot=$extdir

for file in $files ; do
	outfile=`basename $file | sed 's/.pod/.html/'`
	outdir=`dirname $file | sed 's/^pod/html/'`
	mkdir -p $outdir
	$pod2html infile=$file --outfile=$outdir/$outfile
	
done

