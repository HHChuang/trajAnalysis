#!/bin/bash 
#########################################################################
# Program:																#
#	Classify trajectories into two groups.								#
#   Prerequisite program: CountProg.f90 (classify trajectories)         #
#																		#
# Input:																#
#	1. trajlist.dat (list of trajectories)                              #
#   2. defR.dat															#
#	3. defProd1.dat														#
#	4. defProd2.dat														#
#																		#
# Output:																#
#   files                                                               #
#       1. $home/RP1list.dat                                            #
#       2. $home/RP2list.dat                                            #
#       3. $home/analysesTraj.dat                                       #
#   directories                                                         #
#       1. $RP1dir                                                      #
#       2. $RP2dir													    #
#																		#
# History:																#
# 2018/12/14, Grace, the previous one just disappear! fuck!!			#
# 2020/09/26, Grace, change the structure of programs                   #
#########################################################################

function main(){
    # 1. assign variables
    countProg='/Users/Grace/GoogleNTU_Drive/Code/GitHub/trajAnalysis/src/CountProd' # path of program
    trajlist=$1 # ls | grep ^Traj'[0-9]' > trajlist.dat
    defR=$2
    defP1=$3
    defP2=$4
    home=`pwd`
    trajdir="$home/traj"
    RP1dir="$home/RP1/"
    RP2dir="$home/RP2/"

    # 2. execute program, CountProd.90 
    cp $trajlist $defR $defP1 $defP2 `echo $trajdir` 
    cd $trajdir
    #
    execCountProd $trajlist $defR $defP1 $defP2 # output: record.dat
    #
    rm -f $trajlist $defR $defP1 $defP2 
    mv -f record.dat $home 
    cd $home 

    # 3. std-out result # input: record.dat (then remove it in CountAndStdout() )
    CountAndStdout 
}

function execCountProd(){
    # $1 = trajlist
    # $2 = $defR
    # $3 = $defP1
    # $4 = $defP2
    
    trajlist=$1
    defR=$2
    defP1=$3
    defP2=$4

    rm -f record.dat
    echo 'If there are more than 100 trajectories, '
    echo 'print the result one-by-one. '
    num=$(wc -l `echo $trajlist` | awk '{print $1}')
    if [ $num -gt  100 ] 
    then
        for name in `cat $(echo $trajlist)` 
        do
            output=$($countProg $name $defR $defP1 $defP2)
            record=$(echo $output | sed 's/This last point of one direction is://g'| awk '{print $1,$2}')
            echo $name $record >> record.dat
            echo $name $record
        done
    else 
        for name in `cat $(echo $trajlist)` 
        do 
            output=$($countProg $name $defR $defP1 $defP2)
            record=$(echo $output | sed 's/This last point of one direction is://g'| awk '{print $1,$2}')
            echo $name $record >> record.dat
        done
    fi
    rm -f trajlist.dat
}

function CountAndStdout(){
    NN=$(grep -c 'none none' record.dat)
    RR=$(grep -c 'R R' record.dat)
    P1P1=$(grep -c 'P1 P1' record.dat)
    P2P2=$(grep -c 'P2 P2' record.dat)
    NR=$(grep -c 'none R' record.dat)
    NP1=$(grep -c 'none P1' record.dat)
    NP2=$(grep -c 'none P2' record.dat)
    P1P2=$(grep -c 'P1 P2' record.dat)
    #
    RP1_1=$(grep -c 'R P1' record.dat)
    RP1_2=$(grep -c 'P1 R' record.dat)
    RP1=$(($RP1_1+$RP1_2))
    #
    RP2_1=$(grep -c 'R P2' record.dat)
    RP2_2=$(grep -c 'P2 R' record.dat)
    RP2=$(($RP2_1+$RP2_2))
    #
    tot=$(($NN+$RR+$P1P1+$P2P2+$NR+$NP1+$NP2+$P1P2+$RP1+$RP2))

    # make RP1 RP2 list and then copy selected trajectories
    grep 'R P1' record.dat | awk '{print $1}'   >   RP1list.dat
    grep 'P1 R' record.dat | awk '{print $1}'   >>  RP1list.dat
    grep 'R P2' record.dat | awk '{print $1}'   >   RP2list.dat
    grep 'P2 R' record.dat | awk '{print $1}'   >>  RP2list.dat
    rm -f record.dat
    
    rm -rf $RP1dir $RP2dir 
    mkdir $RP1dir
    mkdir $RP2dir 

    for name in `cat RP1list.dat`
    do 
        # mv reorder.$name $RP1dir
        cp $trajdir/$name $RP1dir
    done
    for name in `cat RP2list.dat`
    do 
        # mv reorder.$name $RP2dir
        cp $trajdir/$name $RP2dir
    done

cat << EOF | tee $home/analyseTraj.dat
----------------------------------------------------------------

    Analyse the initial/final point of all the trajectories 
    
output:
    files: 
        RP1list.dat, RP2list.dat and analysesTraj.dat 
    directories:
        1. $RP1dir
        2. $RP2dir

std-out: 
total traj.: $tot

OtherOther: $NN
RR: $RR
P1P1: $P1P1
P2P2: $P2P2
OtherR: $NR
OtherP1: $NP1
OtherP2: $NP2
P1P2: $P1P2

RP1: $RP1
RP2: $RP2
----------------------------------------------------------------
EOF
}

main $@