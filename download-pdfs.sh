for i in {1..9};
do
    wget --no-clobber -P "list${i}" "https://cs.pwr.edu.pl/kobylanski/dydaktyka/resources/pl_lista${i}.pdf";
done;

mkdir -p lectures

wget --no-clobber -P lectures/ "https://cs.pwr.edu.pl/kobylanski/dydaktyka/resources/pl_wyk"{1..14}".pdf"
