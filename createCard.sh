  echo "Card id?: "
  read cardId
  cardFileName="cards/card${cardId}.card"
  echo "Expansion: "
  read expansion
  echo "Effect: "
  read effect
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
  echo "expansion=${expansion}" >>$cardFileName
  echo "effect=${effect}" >>$cardFileName
  echo "atk=${atk}" >> $cardFileName
  echo "hp=${hp}" >> $cardFileName
  echo "name=${name}" >> $cardFileName
  echo "description=${description}" >> $cardFileName
  echo "cost=${cost}" >>$cardFileName
  echo "rarity=${rarity}" >>$cardFileName

