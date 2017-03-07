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

## Running an Instance on jupyter

```
 docker run -i -t -p 8888:8888 anaconda1.2 /bin/bash -c "/root/anaconda/bin/conda install jupyter -y --quiet && mkdir /opt/notebooks && /root/anaconda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser"
```
## Before using casa from jupyter the working directory and Logging files need to be combined.

```
import drivecasa
import logging
base = 'base_name'
timestamp = time.strftime("%d%b%Y_%H%M%S", time.localtime())
logfile = 'casa'+base+'_'+timestamp+'.log' 

logger = logging.getLogger(__name__)
logging.basicConfig(filename = logfile, level=logging.DEBUG) #The logging level 
casa = drivecasa.Casapy(casa_logfile=logfile,working_dir = working_directory)
```
For instructions on how to use a logger see the [python documentation](https://docs.python.org/2/library/logging.html#module-logging)

# To use drive-casa within jupyter without logging 
```
import drivecasa
casa = drivecasa.Casapy()
```
To then pass a list of commands into casa use a python list.
```
Script = []
Script.append("[Casa-Instruction]")
casa.run_script(Script)
```
Additinally a text file containing a new casa command on each line can be run using
```
casa.run_script_from_file("textfile.txt")
```
# Using GUI in jupyter: (this needs to be filled in once arcade is running again)

plotcal(showgui=False (Default:True), figfile=<filename>)

plotants(figfile=<filename>)
https://casa.nrao.edu/docs/taskref/plotants-task.html

plotms(plotfile=<filename>, overwrite=True (Default:False), showgui=False (Default:True)) 
https://casa.nrao.edu/docs/taskref/plotms-task.html

viewer(outfile=<filename>, gui=False (Default:True))
https://casa.nrao.edu/docs/taskref/viewer-task.html

imview(out=<filename>)
https://casa.nrao.edu/docs/taskref/imview-task.html

msview(outfile=<filename>, gui=False (Default:True))
https://casa.nrao.edu/docs/taskref/msview-task.html

To use plotms:

To use imview:

To use ...:

How to open a png image in jupyter:
```
Imview("Image.png")
```

##Credit

Tim Standley for [Drive-Casa github](https://github.com/timstaley/drive-casa), [research paper](http://ascl.net/1504.006)

## Troubleshooting

Casa complains that libraries are missing:
  import the missing library that casa says is missing
  run ldd path/to/casa/release/lib/python2.7/lib-dynload/_hashlib.so
      if any of the listed libraries say 'not found' next to the library name, install these
      
terminal complains that casa is not a recognised command
  ```
  EXPORT PATH=$PATH:path/to/casa/release/bin  
  ```
  
Images are not displayed in jupyter
  Confirm that the png of the image is created in your notebook
  use imview('image.png') within jupyter to display the image.
