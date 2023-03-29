clear
mkdir build
cp ./test.facile ./build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -Wcounterexamples
make 
