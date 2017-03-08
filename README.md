# ArcadePipeline
A project for running CASA commands through the jupyter notebook using drive-casa with support for parallelism on the ARC cluster using Docker containers

## Installation

To install Docker:
```
apt-get update
apt-get -y install docker-engine
```
For more information and tutorials on using docker, visit [Docker Tutorial](https://docs.docker.com/learn/)

The Nodes can be built and run from the Dockerfile using the commands. Once an image is run it runs as a container.
```
docker build -t <name_of_image> .
docker run -i -t <name_of_image>
```
Once the image has been run once, to run it again don't use the above command, but rather use:
```
docker start <id of container>
docker attach <id of container>
```
To view all images available use
```
docker images
```
To view all containers
```
docker ps -a
```
In order to install the docker image and create a container that includes Jupyter Notebook, CASA and Drive-Casa, download the files included in the ArcadePipeline github. Place any ipynb files and Radio Astronomy data in tar.gz format that you wish to be copied into the container in the same folder as the Dockerfile. Run the astropipe.sh file via the following command:
```
bash astropipe.sh
```
This will automatically create the astropipe docker image and create a container that opens an instance of the Jupyter Notebook with access to any ipynb and data files that were included in the same folder as the dockerfile during installation. Note that any tar.gz files will be automatically extracted during the installation.

The astropipe docker image is built on an Ubuntu:16.04 image and contains installations of:
+ [Anaconda] (https://www.continuum.io/)(which includes amongst other libraries, python2.7 and Jupyter) 
+ [Casa] (https://casa.nrao.edu/)
+ [Drive-Casa] (https://github.com/timstaley/drive-casa)

## Setup a Jupyter Notebook instance from the astropipe docker image

To run a Jupyter Notebook through a docker container a container must be created using the following command
```
 docker run -i -t -p 8888:8888 astropipe /bin/bash -c "/root/anaconda/bin/conda install jupyter -y --quiet && /root/anaconda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser"
```
The container name 'astropipe' can be changed to the name of the docker image if an alternative name was used during setup. The command '-p' creates a port, in this case port:8888 through which to connect to the Jupyter Notebook instance. After running this commant the terminal will provide a URL to connect to the Jupyter Notebook via a browser. To open this docker container again once it has been started and closed use the start/attach commands mentioned above.

## Before using casa from jupyter the working directory and Logging files need to be combined.

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
# Running Casa imaging commands in jupyter:

The Casa imaging programs utilize a GUI to edit and save the images. When running CASA through drive-casa in the Jupyter Notebook additional windows cannot be opened. Therefore, when using the imaging commands, additional arguments, in order to prevent the GUI from opening and to output the image file to a desired location, must be added to the imaging function call.

**NOTE** that currently plotms() does not work from a Juptyer Notebook as this function requires a DISPLAY variable to be set and will throw an error even if a dummy DISPLAY variable is set.

```
plotcal( ... , showgui=False , figfile=<filename>)
```
Full documentation on [plotcal](https://casa.nrao.edu/docs/taskref/plotcal-task.html).
```
plotants( ... , figfile=<filename>)
```
Full documentation on [plotants](https://casa.nrao.edu/docs/taskref/plotants-task.html).
```
plotms( ... , plotfile=<filename>, overwrite=True, showgui=False ) 
```
Full documentation on [plotms](https://casa.nrao.edu/docs/taskref/plotms-task.html).
```
viewer( ... , outfile=<filename>, gui=False)
```
Full documentation on [viewer](https://casa.nrao.edu/docs/taskref/viewer-task.html).
```
imview( ... , out=<filename>)
```
Full documentation on [imview](https://casa.nrao.edu/docs/taskref/imview-task.html).
```
msview( ... ,outfile=<filename>, gui=False)
```
Full documentation on [msview](https://casa.nrao.edu/docs/taskref/msview-task.html).
```
plotms( ... , plotfile=<filename>, overwrite=True, showgui=False ) 
```
Full documentation on [plotms](https://casa.nrao.edu/docs/taskref/plotms-task.html).


## How to open an image in a jupyter notebook:
```
from IPython.display import Image
Image(<filename>)
```


##Credit

Tim Standley for [Drive-Casa github](https://github.com/timstaley/drive-casa), [research paper](http://ascl.net/1504.006)

## Troubleshooting

**Casa complains that libraries are missing:**
Import the missing library that casa says is missing. Check which files are missing by running the following command:
```
ldd path/to/casa/release/lib/python2.7/lib-dynload/_hashlib.so
```
If any of the listed libraries say 'not found' next to the library name, install these files using 
```
'apt-get install <libname>'.
```

**Terminal complains that casa is not a recognised command**
```
EXPORT PATH=$PATH:path/to/casa/release/bin  
```
  
**Images are not displayed in jupyter**
Confirm that the png of the image is created in your notebook
Use Image(filename='/path/to/images/image.png') within jupyter to display the image.
