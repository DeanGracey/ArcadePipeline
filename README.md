# ArcadePipeline
A project for running CASA commands through the jupyter terminal with support for parallelism on the ARC cluster

## Installation

To install Docker:
```
apt-get update
apt-get -y install docker-engine
```
For more information and tutorials on using docker, visit [Docker Tutorial](https://docs.docker.com/learn/)

The Nodes can be built and run from the Dockerfile using the commands. Once an image is run it runs as a container.
```
docker build -t [name_of_image] .
docker run -i -t [name_of_image]
```
Once the image has been run once, to run it again don't use the above command, but rather use:
```
docker start *id of image*
docker attach *id of image*
```
To view all images available use
```
docker images
```
To view all running containers
```
docker ps -a
```
The head node docker image is built on an Ubuntu:16.04 image and contains installations of:
+ [Anaconda] (https://www.continuum.io/)(which includes amongst other libraries, python2.7 and Jupyter) 
+ [Casa] (https://casa.nrao.edu/)
+ [Drive-Casa] (https://github.com/timstaley/drive-casa)

##Running an Instance on jupyter

# To use drive-casa within jupyter (this needs to be verified (syntax) once arcade is running again)
```
import drivecasa
```
To then pass a list of commands into casa use a python list.
```
Script = []
Script.append("[Casa-Instruction]")
drivecasa.run_script(Script)
```
Additinally a text file containing a new casa command on each line can be run using
```
drivecasa.run_script_from_file("textfile.txt")
```
# Using GUI in jupyter: (this needs to be filled in once arcade is running again)

To use plotms:

To use imview:

To use ...:

How to open a png image in jupyter:
```
Imview("Image.png")
```

##Credit

Tim Standley for [Drive-Casa github](https://github.com/timstaley/drive-casa), [research paper](http://ascl.net/1504.006)
