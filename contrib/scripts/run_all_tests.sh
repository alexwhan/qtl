#! /bin/sh
#
# Usage: contrib/scripts/run_all_tests.sh .

path=$1

echo "* Run all functional/regression/unit/check tests for R/qtl on $path"
if [ ! -z $path -a -d $path ]; then
  cd $path
fi
echo -n "Using: "
pwd
if [ ! -d "contrib" ]; then
  echo "Incorrect path for R/qtl source"
  exit 1
fi
cwd=`pwd`

echo "* Run the standard MQM regression tests - without R install"
cd $cwd
cd contrib/bin
rm CMakeCache.txt
cmake .
make clean
make 
make test
if [ "$?" -ne "0" ]; then
  echo "Test 'standalone' failed"
  exit 1
fi

echo "* Run R CMD check"
cd $cwd
R CMD check .
if [ "$?" -ne "0" ]; then
  echo "Test 'R CMD check' failed"
  exit 1
fi

echo "* Run the R regression tests - with R install from CMakeLists.txt"
cd $cwd
cd contrib/bin
rm CMakeCache.txt
cmake -DTEST_R=TRUE .
make clean
make 
make testR
if [ "$?" -ne "0" ]; then
  echo "Test 'R regression tests' failed"
  exit 1
fi

echo "* Generate PDF's"
echo "== skipped =="
