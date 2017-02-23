# ArcadePipeline
A project for running CASA commands through the jupyter terminal with support for parallelism on the ARC cluster

## Installation

To install Docker:
```
apt-get update
apt-get -y install docker-engine
```
For more information and tutorials on using docker, visit [Docker Tutorial](https://docs.docker.com/learn/)

To donwload and run the docker image *casa-project*:
```
docker pull jeremysmith123/casa-project
docker run -i -t *id of image*
```
Once the image has been run once, to run it again don't use the above command, but rather use:
```
docker start *id of image*
docker attach *id of image*
```
The head node docker image is built on an Ubuntu  contains installations of:
+ [Anaconda] (https://www.continuum.io/)(which includes amongst other libraries, python2.7 and Jupyter) 
+ [Casa] (https://casa.nrao.edu/)
+ [Drive-Casa] (https://github.com/timstaley/drive-casa)
  

##Credit

Tim Standley for [Drive-Casa github](https://github.com/timstaley/drive-casa), [research paper](http://ascl.net/1504.006)
