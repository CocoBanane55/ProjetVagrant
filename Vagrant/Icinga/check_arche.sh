#!/bin/bash

value=$(curl -s https://arche.univ-lorraine.fr/live-stats/stats.json | grep liveuser | tr -dc 0-9)

if [ $value -lt 2000 ]; then
    echo "OK : Le nombre d'étudiants connectés est inférieur à 2000"
    exit 0
elif [ $value -lt 3000 ]; then
    echo "WARNING : Le nombre d'étudiants connectés est inférieur à 3000 mais supérieur à 2000"
    exit 1
elif [ $value -gt 3000 ]; then
    echo "CRITICAL : Le nombre d'étudiants connectés est supérieur à 3000 !"
    exit 2
else
    echo "UNKNOWN : Le nombre d'étudiants connectés est inconnue"
    exit 3
fi
