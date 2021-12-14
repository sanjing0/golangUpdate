#!/bin/bash

#Upgrade go to latest version or desinnated version

readonly url='https://go.dev/dl/'
fileName=""
readonly goRoot='/usr/local/'
readonly pkgPath=$goRoot'go'
readonly selfName=$0
readonly retryTimes=1000

getLatestVersion()
{
    wget --tries=$retryTimes $url
    fileName=$(grep '<span class="filename">' index.html | grep '.linux' | awk -F">" '{print $2}' | awk -F"<" '{print $1}')
    echo latest go version package $fileName
}

downLoadPkg(){
    echo "start download package $fileName"
    readonly goFilePath=$url$fileName
    wget --tries=$retryTimes $goFilePath
    echo "download package $fileName end"
}

installPkg(){
    if [ ! -e $fileName ]; then
        echo "file $fileName not exist"
        return
    fi
 
    echo "start install package $fileName ..."
    if [ -e $pkgPath ]; then
        sudo rm -r $pkgPath
    fi
    sudo tar -C $goRoot -xzf $fileName
    echo "install package $fileName end"
}

clearDir(){
    echo clearDir
    fileList=$(ls)
    for elemFile in ${fileList[@]}
    do
        if [[ ./$elemFile = $selfName ]]; then
            continue
        else
            rm --verbose -r $elemFile
        fi
    done
}

startUpdate() {
    downLoadPkg
    installPkg
    clearDir
}

clearDir
if [ ! $# == 0 ]; then
    readonly version=$1
    echo $version
    fileName="go$version.linux-amd64.tar.gz"
else
    getLatestVersion
fi
echo --------------golang curVersion $fileName---------------

if [ -z $fileName ]; then
    echo --------------get golang version id failed--------------
    exit
fi

startUpdate
