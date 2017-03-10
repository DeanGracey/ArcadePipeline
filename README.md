# ArcadePipeline
A project for running Casa commands through Jupyter Notebook using Drive-Casa with the intention for future support for parallelism on the ARC cluster using Docker containers

## For a guide to prototpying process see "Building a Docker" at the end of the Readme

## Installation

To install Docker:
```
apt-get update
apt-get -y install docker-engine
```
OR
```
curl -fsSL https://get.docker.com/ | sh
```
Add yourself to the docker user group:
```
sudo usermod -aG docker <username>
```
For more information and tutorials on using docker, visit [Docker Tutorial](https://docs.docker.com/learn/)

The docker images can be built and run from the Dockerfile using the following command. The Dockerfile must be in your current directory. When you run an image a container using that image is created. Don't forget the '.' at the end of the *build* command - this indicates the Dockerfile is in your current directory.
```
docker build -t <image_name> .
docker run -i -t <image_name>
```
Once the image has been run once, to run it again don't use the above command, but rather use:
```
docker start <container_id>
docker attach <container_id>
```
To view all images available use
```
docker images
```
To view all containers
```
docker ps -a
```
To mount a volume from the host machine into the docker container
```
docker run -it -v /path/to/folder/on/host:/path/to/folder/in/container <name_of_image> /bin/bash
```
To copy files out of and into the container respectively
```
docker cp [options] <container>:/path/to/source /path/to/destination
docker cp [options] /path/to/source <container_id>:/path/to/destination
```
In order to install the docker image and create a container that includes Jupyter Notebook, Casa and Drive-Casa, download the files included in the ArcadePipeline github. Place any ipynb files (or ipynb tutorial files) and Radio Astronomy data in tar.gz format that you wish to be copied into the container in the same folder as the Dockerfile. Run the astropipe.sh file via the following command:
```
bash astropipe.sh
```
This will automatically create the astropipe docker image and create a container that opens an instance of the Jupyter Notebook with access to any ipynb and data files that were included in the same folder as the dockerfile during installation. Note that any tar.gz files will be automatically extracted during the installation.

The astropipe docker image is built on an Ubuntu:16.04 image and contains installations of:
+ [Anaconda] (https://www.continuum.io/) (which includes amongst other libraries, python2.7 and Jupyter) 
+ [Casa] (https://casa.nrao.edu/)
+ [Drive-Casa] (https://github.com/timstaley/drive-casa)

## Setup a Jupyter Notebook instance from the astropipe docker image

To run a Jupyter Notebook through a docker container a container must be created from a docker image containing Jupyter Notebook using the following command
```
 docker run -i -t -p 8888:8888 astropipe /bin/bash -c "/root/anaconda/bin/conda install jupyter -y --quiet && /root/anaconda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser"
```
The container name 'astropipe' can be changed to the name of the docker image if an alternative name was used during setup. The command '-p' creates a port, in this case port:8888 through which to connect to the Jupyter Notebook instance. After running this commant the terminal will provide a URL to connect to the Jupyter Notebook via a browser. To open this docker container again once it has been started and closed use the *start/attach* commands mentioned above.

## Before using CASA from Jupyter the working directory and Logging files need to be combined.

In order to be able to write to the same logger as CASA and drive-casa during your python script the loggers need to be combined. The *working_Directory* variable is set to '/opt/notebooks' so that the logger information is output to a text file that is accessable from the Jupyter Notebook file system.

```
import drivecasa
import logging
base = 'base_name_of_data'
working_Directory = '/opt/notebooks'
timestamp = time.strftime("%d%b%Y_%H%M%S", time.localtime())
logfile = 'casa_'+base+'_'+timestamp+'.log' 

logger = logging.getLogger(__name__)
logging.basicConfig(filename = logfile, level = logging.DEBUG) #the logging level set to DEBUG 
casa = drivecasa.Casapy(casa_logfile = logfile, working_dir = working_Directory)
```
For instructions on how to use a logger see the [python documentation](https://docs.python.org/2/library/logging.html#module-logging)

## To use drive-casa within Jupyter without logging 
```
import drivecasa
casa = drivecasa.Casapy()
```
## Passing commands/scripts to Casa through Drive-Casa 

To pass a list of commands into casa use a python list.
```
script = []
script.append("[Casa-Instruction]")
casa.run_script(script)
```
Additionally a text file containing a new Casa command on each line can be run using
```
casa.run_script_from_file(<name_of_textfile>)
```
# Running Casa imaging commands in Jupyter Notebook:

The Casa imaging tasks utilize a GUI to edit and save the images. When running Casa through Drive-Casa in the Jupyter Notebook additional windows cannot be opened. Therefore, when using the imaging commands, additional arguments, in order to prevent the GUI from opening and to output the image file to a desired location, must be added to the imaging function call.

**NOTE** that currently plotms() does not work from a Juptyer Notebook as this function requires a DISPLAY variable to be set and will throw an error even if a dummy DISPLAY variable is set.

```
plotcal( ... , showgui=False , figfile=<filename>)
```
See full documentation on [plotcal](https://casa.nrao.edu/docs/taskref/plotcal-task.html).
```
plotants( ... , figfile=<filename>)
```
See full documentation on [plotants](https://casa.nrao.edu/docs/taskref/plotants-task.html).
```
plotms( ... , plotfile=<filename>, overwrite=True, showgui=False ) 
```
See full documentation on [plotms](https://casa.nrao.edu/docs/taskref/plotms-task.html).
```
viewer( ... , outfile=<filename>, gui=False)
```
See full documentation on [viewer](https://casa.nrao.edu/docs/taskref/viewer-task.html).
```
imview( ... , out=<filename>)
```
See full documentation on [imview](https://casa.nrao.edu/docs/taskref/imview-task.html).
```
msview( ... ,outfile=<filename>, gui=False)
```
See full documentation on [msview](https://casa.nrao.edu/docs/taskref/msview-task.html).
```
plotms( ... , plotfile=<filename>, overwrite=True, showgui=False ) 
```
See full documentation on [plotms](https://casa.nrao.edu/docs/taskref/plotms-task.html).


## How to open an image in a Jupyter Notebook:
```
from IPython.display import Image
Image(<filename>)
```
See additional documentation on [IPython.Display.Image](https://ipython.org/ipython-doc/3/api/generated/IPython.display.html).
## Credit

Tim Standley for [Drive-Casa github](https://github.com/timstaley/drive-casa), [research paper](http://ascl.net/1504.006)

## Troubleshooting

**Casa complains that libraries are missing:**
Import the missing library that casa says is missing. Check which dependencies are missing by running the following command:
```
ldd path/to/casa/release/lib/python2.7/lib-dynload/_hashlib.so
```
If any of the listed libraries say 'not found' next to the library name, install these files using 
```
apt-get install <libname>
```

**Terminal complains that casa is not a recognised command**
```
EXPORT PATH=$PATH:path/to/casa-release/bin  
```
  
**Images are not displayed in jupyter**
Confirm that the png of the image is created in your notebook
Use Image(filename='/path/to/images/image.png') within jupyter to display the image.

## Building A Docker 
From the experience gained in building the Arcade Pipleline, the easiest prototyping process for building a Docker image is described below

After install Docker pull a base operating system to build the Docker on. (Alternativly pull an image that already contains the largest part of your environment eg docker pull python:2.7)
```
docker pull ubuntu:16.04
```
Find out the image id of the container
```
docker images
```
Run the image to create a container
```
docker run -it <id-of-image>
```
Now the terminal is in the container in a bash shell. Start with apt-get update, this will ensure that downloads of software download the latest versions. Treat the containter as if it were your own machine, installing software as usuall. To download software you will need wget so install wget
```
apt-get update
aptget install wget
```
Now you can download and install software as you normally would through the terminal. Once all software is intalled and you have verified that it runs correctly, you can use the history command to see all the commands that you typed into the terminal. Copy the commands that worked in setting up your environment and put them in a Dockerfile that follows the same format as the Dockerfile above. Now follow the same process described above to rebuild the image from the Dockerfile to ensure the process worked.

Building the image in this way rather than using a Dockerfile first saves on development time as the build process is interactive rather than running a script and reiteratively correcting errors and rebuilding the image. 
