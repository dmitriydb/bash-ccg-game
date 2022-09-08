declare -A cardRarity

CARDS_IN_BOOSTER=5
BOOSTER_PRICE=100

cardRarity['basic']=40
cardRarity['bronze']=35
cardRarity['silver']=20
cardRarity['gold']=4
cardRarity['legendary']=1

boosterRarity=('legendary' 'gold' 'silver' 'bronze' 'basic')

expansion=""

if [[ $# -ne 0 ]]; then
  expansion=$1
fi

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

function openBooster() {
  cardsQty=$CARDS_IN_BOOSTER
  booster=()
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
   cards=()
   for file in ./cards/card*.card; do
     if cat $file | grep -q ${newCardRarity}; then
        cardName=$( cat $file | grep -o name=.* )
        if [[ -n $expansion ]]; then
          if  cat $file | grep -q expansion=${expansion}; then
            cardName=${cardName#name=}
            cards+=($cardName)
          else
            continue
          fi
        else
          cardName=${cardName#name=}
          cards+=($cardName)
        fi
     fi
   done
  cardIndex=$(($RANDOM%${#cards[@]}))
  cardName=${cards[${cardIndex}]}
  echo "${i}. ${cardName}"
  echo $cardName >> library.txt
  booster+=($cardName)
done

  while true; do
    printf "Press any key to continue or the card number to show info: \n"
    read -n 1 option
    echo
    if [[ -z option ]]; then
      break;
    fi
    option=$(($option-1))
    cardName=${booster[${option}]}
    for file in ./cards/card*.card; do
     if cat $file | grep -q "name=${cardName}"; then
       cat $file
       echo
       echo
     fi
     done
    for ((i=0 ; i<$CARDS_IN_BOOSTER; i++ )); do
      echo "$(($i+1)). ${booster[${i}]}"
    done
  done

}

function passRarity() {
  if [[ $1 -lt ${cardRarity[$2]} ]]; then
   return 0
  else
   return 1
  fi
}

money=$( cat currency.txt )
if [[ $money -lt $BOOSTER_PRICE ]]; then
  echo "Booster price is $BOOSTER_PRICE, but you have only $money"
else
  negativePrice=$(($BOOSTER_PRICE * -1))
  $( ./addCurrency.sh $negativePrice )
  openBooster
fi
