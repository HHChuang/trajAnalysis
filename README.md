# Dynamics
Analyse the last point of a trajectory with its two directions, and then assign the product name by the user-define criteria. 
---
## Step1. compile forturn source code 

`ifort -debug all -o countProd countProd.f90`

- the executable file names countProd
- you can add more flags while compiling

## Step2. instruction of input files in directory `run`

1. Traj
2. defR.dat
3. defProd1.dat
4. defProd2.dat


- Traj: serious of structures (XYZ coordinate)
    - first line: amount of atom
    - second line: comment line
    - following line: XYZ coordinat
     
  and then, repeat this format.

     <div style='float: center'>
        <img style='width: 400px' src="./fig/traj.png"></img>
    </div> 
- 3 user-defined criteria (defR.dat, defProd1.dat and defProd2.dat)
    <div style='float: center'>
        <img style='width: 500px' src="./fig/def.png"></img>
    </div> 
    There are 3 types of geometric parameters need to be defined, and the format is same. First, the amount of criterion, i.e. 2 criteria to define dihedral angle in the above example. Second, user-defined value and logic operator, i.e. dihedral angle for atom 3-1-5-4 is grater than -90 degree and less than 90 degree. Make sure use `gt` and `lt` correctly, and use logical operator `and` and `or`. Add `end` in the last one. 

## Step3. screenshot for demonstration
- Execute this program
    <div style='float: center'>
        <img style='width: 400px' src="./fig/demo1.png"></img>
    </div> 

- Redirect the std-out information in one file, and then you can use shell script to analyse all trajectories in the same directory.
    <div style='float: center'>
        <img style='width: 400px' src="./fig/demo2.png"></img>
    </div> 
