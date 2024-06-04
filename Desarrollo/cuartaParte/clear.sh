for i in `ls tests`;
do
    rm -f tests/$i/*.out
done

rm -f myTests/frontend/*.out
