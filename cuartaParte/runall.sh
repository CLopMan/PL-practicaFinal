for i in `ls tests`
do
    for x in `ls tests/$i`
    do
        ./run.sh tests/$i/$x
    done
done
