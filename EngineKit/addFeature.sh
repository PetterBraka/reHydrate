#!/bin/sh
echo "What is the name of the feature? \n example: FeatureService"
read name

sourcePath="./Sources/"$name"/Sources"
interfacePath="./Sources/"$name"/Interface"
mockPath="./Sources/"$name"/Mocks"
testsPath="./Sources/"$name"/Tests"

mkdir -p $sourcePath $interfacePath $mockPath $testsPath

touch $sourcePath"/empty.swift"
touch $interfacePath"/empty.swift"
touch $mockPath"/empty.swift"
touch $testsPath"/empty.swift"
