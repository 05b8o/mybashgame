#!/bin/bash
m0='E' #goal
m1='P' #player
m2='#' #wall
m3="." #space
key=-1 #0:up 1:down 2:left 3:right 
ShowMap(){
    for((i=0;i<$c;i++))
    do
        echo ${map[$i]}
    done
}
KeyIn(){
    escape_char=$(printf "\u1b")
    read -rsn1 mode # get 1 character
    if [[ $mode == $escape_char ]]; then
        read -rsn2 mode # read 2 more chars
    fi
    case $mode in
        '[A') key=0 ;;#up
        '[B') key=1 ;;#down
        '[D') key=2 ;;#left
        '[C') key=3 ;;#right
        *) >&2  return ;;
    esac
}


c=0
playerx=0 #player x
playery=0 #player y
endx=0 #goal x
endy=0 #goal y
clear
for line in $(cat $1)
do
    accounts[$c]=$line
    #get play,goal position
    for((pos=0;pos<${#line};pos++))
    do
        if [ ${accounts[$c]:$pos:1} == 0 ] ;then #goal
            endx=$pos
            endy=$c
            echo getgoal $endx,$endy
        fi

        if [ ${accounts[$c]:$pos:1} == 1 ] ;then #player
            playerx=$pos
            playery=$c
            echo getplayer $playerx,$playery
        fi
    done
    #set map
    map[$c]=`echo ${accounts[$c]//0/$m0}`
    map[$c]=`echo ${map[$c]//1/$m1}`
    map[$c]=`echo ${map[$c]//2/$m2}`
    map[$c]=`echo ${map[$c]//3/$m3}`
    #echo ${map[$c]}
    ((c++))
done

isgame=true
while [ $isgame == true ]
do
    clear
    ShowMap
   
    #echo $playerx,$playery,$endx,$endy
    if [ $playerx == $endx ] && [ $playery == $endy ];then
        isgame=false
        break
    fi

    KeyIn
    case $key in
    0) #echo ${map[$playery-1]:$playerx:1}
       if [ ${map[$playery-1]:$playerx:1} == $m3 ] || [ ${map[$playery-1]:$playerx:1} == $m0 ]  ; then
          map[$playery-1]="${map[$playery-1]:0:playerx}$m1${map[$playery-1]:playerx+1}"
          map[$playery]="${map[$playery]:0:playerx}$m3${map[$playery]:playerx+1}"
          ((--playery))
       fi;;
    1) #echo ${map[$playery+1]:$playerx:1}
       if [ ${map[$playery+1]:$playerx:1} == $m3 ] || [ ${map[$playery+1]:$playerx:1} == $m0 ]; then
          map[$playery+1]="${map[$playery+1]:0:playerx}$m1${map[$playery+1]:playerx+1}"
          map[$playery]="${map[$playery]:0:playerx}$m3${map[$playery]:playerx+1}"
          ((++playery))
       fi;;
    2) #echo ${map[$playery]:$playerx-1:1}
       if [ ${map[$playery]:$playerx-1:1} == $m3 ] || [ ${map[$playery]:$playerx-1:1} == $m0 ]; then
          map[$playery]="${map[$playery]:0:playerx-1}$m1${map[$playery]:playerx}"
          map[$playery]="${map[$playery]:0:playerx}$m3${map[$playery]:playerx+1}"
          ((--playerx))
       fi;;
    3) #echo ${map[$playery]:$playerx+1:1}
       if [ ${map[$playery]:$playerx+1:1} == $m3 ]|| [ ${map[$playery]:$playerx+1:1} == $m0 ]; then
          map[$playery]="${map[$playery]:0:playerx+1}$m1${map[$playery]:playerx+2}"
          map[$playery]="${map[$playery]:0:playerx}$m3${map[$playery]:playerx+1}"
          ((++playerx))
       fi;;
    esac
    #isgame=false

done

echo You Win!!!!!!!!!!!!!!!!!
