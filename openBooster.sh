declare -A cardRarity

CARDS_IN_BOOSTER=5

cardRarity['basic']=40
cardRarity['bronze']=35
cardRarity['silver']=20
cardRarity['gold']=4
cardRarity['legendary']=1

boosterRarity=('legendary' 'gold' 'silver' 'bronze' 'basic')

function loadCard() {
  cardId=$1
  cardFileName="cards/card${cardId}.card";
  cat $cardFileName | while read line; do
   paramName=$( echo $line | grep -o ^[a-z]* );
   paramValue=$( echo $line | grep -o =.* );
   paramValue=${paramValue:1};
   echo "${paramName} is '${paramValue}'"
  done
}

function createCard() {
  echo "Card id?: "
  read cardId
  cardFileName="cards/card${cardId}.card"
  echo "Atk: "
  read atk
  echo "Hp: "
  read hp
  echo "Name:"
  read name
  echo "Rarity:"
  read rarity
  echo "Description:"
  read description
  echo "Cost:"
  read cost
  rm -f $cardFileName
  echo "atk=${atk}" >> $cardFileName
  echo "hp=${hp}" >> $cardFileName
  echo "name=${name}" >> $cardFileName
  echo "description=${description}" >> $cardFileName
  echo "cost=${cost}" >>$cardFileName
  echo "rarity=${rarity}" >>$cardFileName
}

function openBooster() {
  cardsQty=$CARDS_IN_BOOSTER
  for ((i = 1 ; i <= $cardsQty ; i++));  do
    #Choosing rarity
    newCardRarity='basic'
    for rarityKey in ${boosterRarity[@]}; do
      rarity=${cardRarity[${rarityKey}]}
      rand=$(($RANDOM%100))
      if  passRarity $rand $rarityKey; then
        newCardRarity=$rarityKey
        break
      fi
    done
    #echo $newCardRarity
   cards=()
   for file in ./cards/card*.card; do
     if cat $file | grep -q ${newCardRarity}; then
      cardName=$( cat $file | grep -o name=.* )
      cardName=${cardName#name=}
      cards+=($cardName)
     fi
   done    
  cardIndex=$(($RANDOM%${#cards[@]}))
  cardName=${cards[${cardIndex}]}
  echo "${i}. ${cardName}"
  echo $cardName >> library.txt
  done
}

function passRarity() {
  if [[ $1 -lt ${cardRarity[$2]} ]]; then
   return 0
  else
   return 1
  fi
}

openBooster





