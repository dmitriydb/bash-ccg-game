if [[ $# -lt 1 ]]; then
   echo "Usage: addCurrency <amount to add>"
fi

current=$( cat currency.txt )
new=$((current + $1))
echo $new > currency.txt
