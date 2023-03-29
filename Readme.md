Le langage facile
======

## Description du Projet

Création d'un compilateur pour le langage Facile avec l'utilisation de Flex et Bison. 
Projet de compilation de 3ème année de licence informatique à l'Université de la Rochelle.

## Installation

````bash
sudo apt-get install cmake make mono flex bison libglib2.0-dev -y
````

## Dépendances
* cmake
* make
* mono
* flex
* bison


## Utilisation

Avec le fichier exec.sh
```bash	
sudo chmod +x exec.sh
./exec.sh
./facile <fichier>.facile
```

Sans le fichier exec.sh
```bash
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make
./facile <fichier>.facile
```

Pour la démo utiliser le fichier test.facile
````bash
./facile ../test.facile
````

Si vous voulez obtenir un fichier zip des fichiers sources 
```bash
make package_source
```

## Test du fichier ReadWrite.cs
Utiliser les commandes suivantes pour compiler le fichier ReadWrite.cs et le décompiler en ReadWrite.il
```bash
mcs ReadWrite.cs
monodis ReadWrite.cs > ReadWrite.il
tail -20 ReadWrite.il
```

## Groupe
Pour ce projet nous sommes un groupe de 3 étudiants :
* [PARENTE Florian](https://www.linkedin.com/in/florian-parent%C3%A9-b78644203/)
* [GEOFFROY Thomas]()
* [PIET Romain]()