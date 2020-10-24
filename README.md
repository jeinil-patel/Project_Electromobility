# Project_Electromobility

## Functionalty of the Individual Files

qss_hybrid_electric_vehicle.slx:  Simulation Model (Integral part of QSS toolbox)

src\Controller.m :  Controller for mode switching

src\StartStop.m : start stop for engine

## Interdependencies between individual files

qss_hybrid_electric_vehicle.slx -> src\Controller.m

## Setup

1) Download QSS Toolbox from [Downloads ETH Zürich](https://idsc.ethz.ch/research-guzzella-onder/downloads.html)
2) Copy both files from src to \Functions folder
3) Copy qss_hybrid_electric_vehicle.slx to \Examples\OptimalTransmissionDesign
4) Set current directory to QSS Toolbox in Matlab (add all folders and subfolders to path)
5) Open qss_hybrid_electric_vehicle.slx and select cycle from Driving Cycle block
6) Run Simulation. Enjoy!

## Requirements

@ Matlab 2018 and above. 
