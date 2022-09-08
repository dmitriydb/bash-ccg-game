declare -A library

while read line; do 
  if [[ -n ${library[${line}]} ]]; then
    library[${line}]=$((${library[${line}]} + 1))
  else
    library[${line}]="1"
  fi
done < library.txt

options=()
counts=()

for i in ${!library[@]}; do
  options+=($i)
  count+=(${library[${i}]})
done

qty=${#library[@]}

function showLibrary() {
for ((i = 0 ; i < qty ; i++)); do 
  echo "$((i+1))) ${options[${i}]} x ${count[${i}]}"
done 
}

while true; do
  showLibrary
  echo "Enter card number to show info:"
  read num
  num=$((num-1))
  cardName=${options[${num}]}
  for i in cards/*.card; do
    if cat $i | grep "name=${cardName}"; then
      cat $i
    fi
  done
  echo "==========================================="
done
