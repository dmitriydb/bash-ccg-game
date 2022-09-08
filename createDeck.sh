num=0
decknum=0
deckNameSet=0
declare -A library
declare -A deck

if [[ $# -ne 0 ]]; then
  deckName=$1
  deckNameSet=1
  while read card; do
    if [[ -n ${deck[${card}]} ]]; then
      deck[${card}]=$((${deck[${card}]}+1))
   else
      deck[${card}]="1"
   fi
  done < "decks/${deckName}.deck"
fi

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

function showLibrary() {
qty=${#library[@]}
echo "[---Your library: ---]"
for ((i = 0 ; i < qty ; i++)); do 
  text="$((i+1))) ${options[${i}]} x ${count[${i}]}"
  if [[ $i -eq $num ]]; then
    text="> ${text}"
  fi
  echo $text
done
}

function showDeck() {
echo "[---Your deck: ---]"
i=0
for key in ${!deck[@]}; do
  text="$key x ${deck[${key}]}"
  if [[ $i -eq $decknum ]]; then
    text="> ${text}"
  fi
  i=$((i+1))
  echo ${text}
done
}

function deleteFromDeck() {
echo "[---Your deck: ---]"
i=0
for key in ${!deck[@]}; do
  if [[ $i -eq $decknum ]]; then
    if [[ ${deck[${key}]} -eq 0 ]]; then
      return 0;
    else
      echo "key = ${key}"
      deck[${key}]=$((${deck[${key}]}-1))
      found=0
      for ((j=0 ; j<${#options[@]} ; j++)); do
        if [[ ${options[${j}]} == $key ]]; then
          echo $j
          echo ${options[${j}]}
          count[${j}]=$((${count[${j}]}+1))
          found=1
          break
        fi 
      done
      if [[ found -eq 0 ]]; then
        echo "Setting $key"
        library[${key}]="1"
        options+=($key)
        count+=("1")
      else
        return 0
      fi
    fi
  fi
  i=$((i+1))
done
}


while true; do
  showLibrary
  showDeck
  printf "Press enter to add card into deck. \n[+] and [-] to move between cards in library. \n[q] and [w] to move between cards in your deck.\nPress [S] to save deck. \nPress [d] to delete card from deck.\nYour choice: "
  read -n 1 option
  echo ""
  if [[ $option == 'S' ]]; then
    break;
  fi
  if [[ $option == '-' ]]; then
    num=$((num-1))
    if [[ $num -lt 0 ]]; then
      num=$((${#options[@]}-1))
    fi
    continue;
  fi
  if [[ $option == '+' ]]; then
    num=$((num+1))
    if [[ $num -ge ${#options[@]} ]]; then
      num=0
    fi
    continue;
  fi
  if [[ $option == 'q' ]]; then
    decknum=$((decknum-1))
    if [[ $decknum -lt 0 ]]; then
      decknum=$((${#deck[@]}-1))
    fi
    continue;
  fi

  if [[ $option == "w" ]]; then
    decknum=$((decknum+1))
    if [[ $decknum -ge ${#deck[@]} ]]; then
      decknum=0
    fi
    continue;
  fi
  if [[ $option == "d" ]]; then
    deleteFromDeck
   continue;
  fi

  if [[ -n $option ]]; then
    continue;
  fi
  
  cardName=${options[${num}]}
  left=${count[${num}]}
  if [[ $left -eq 0 ]]; then
    echo "Not enough cards"
  else
    count[${num}]=$((${count[${num}]}-1))
    if [[ -n ${deck[${cardName}]} ]]; then
      deck[${cardName}]=$((${deck[${cardName}]}+1))
    else
      deck[${cardName}]="1"
    fi
  fi
  echo "==========================================="
done

#Saving deck
if [[ $deckNameSet -eq 0 ]]; then
  echo "Deck name?"
  read deckName
fi
fileName="decks/${deckName}.deck"
echo "Saving as ${fileName}"
rm -f $fileName
for card in ${!deck[@]}; do
  qty=${deck[${card}]}
  if [[ $qty -eq 0 ]]; then
    continue;
  fi
  for (( i=0 ; i<$qty ; i++ )); do
   echo $card >> $fileName
  done
done
#Saving library leftovers
cp library.txt library.txt.bak
rm library.txt
for ((i=0 ; i<${#options[@]} ; i++ )); do
  card=${options[${i}]}
  qty=${count[${i}]}
  if [[ $qty -eq 0 ]]; then
    continue;
  fi
  for (( j=0 ; j<$qty ; j++ )); do
   echo $card >> "library.txt"
  done
done
