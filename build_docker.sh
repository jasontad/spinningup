# Build a docker image
docker build -t ubuntu1804 .

# Run the docker image
docker run -v $(pwd):/app -it ubuntu1804

# Change path to the root project
cd /path/to/spinningup 

# Attach shell
source activate base
conda activate spinnup

# Install Spinning Up
pip install -e .

# Run a test
cd test
python test_ppo.py
