# check the NVIDIA driver 
nvidia-smi

# add the NVIDIA package repositories
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo tee /etc/systemd/system/docker.service.d/override.conf <<EOF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd --host=fd:// --add-runtime=nvidia=/usr/bin/nvidia-container-runtime
EOF

# update systemd and restart Docker:
sudo systemctl daemon-reload
sudo systemctl restart docker

# verify if the NVIDIA runtime is available
docker info | grep -i runtime

# run docker image
docker run -v $(pwd):/app -it ubuntu1804

# specific GPU
docker run --gpus '"device=0"' -it ubuntu1804 bash

# the local folder with the files that want to use or share with the container
docker run -v $(pwd):/app --gpus all -it ubuntu1804