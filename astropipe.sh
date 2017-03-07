
docker build -t astropipe .

docker run -i -t -p 8888:8888 astropipe /bin/bash -c "export PATH=$PATH://casa-release-4.7.1-el7/bin && /root/anaconda/bin/conda install jupyter -y --quiet && /root/anaconda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser"

