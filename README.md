# DLDockerTemplate

## Project Description
This project aims to provide `Dockerfile` templates for building Docker images during deep learning research. The created image file:

  1. Comes with the [Miniconda](https://docs.conda.io/projects/miniconda/en/latest/miniconda-install.html) package manager.
  2. Contains the basic dependencies required for the pre-installed programs.
  3. Executes commands with **non-root** privileges to prevent erroneous operations.
  4. Optimizes for domestic and campus network environments.

## How to use
### Edit Dockerfile
Clone this project to your local machine and modify the `MAINTAINER` name in the Dockerfile.

```bash
ENV MAINTAINER <your-name>
```
### Build Container
In the directory containing the Dockerfile, execute the following command to build the base image:

```bash
docker build -t <Image-Name:Tag> .
```
### Run Container
Then, use the following command to mount the code and dataset directories, and activate the container：

```bash
docker run -itd \           
  -v <Path in Host>:<Path in Container> \
  -w <Workdir in Container> \
  -p 6006:6006 \
  --name=<Container Name> \
  --runtime=nvidia \
  --restart unless-stopped \
  --gpus all 
  <Image Name:Tag>
```
`-v` : Mount dataset volumes or code volumes into the container. If you want to mount multiple paths, repeat the use of the -v syntax for mounting.

`-w` : The default path after entering the container.

`-p` : Port mapping between the container and the host machine. 6006 is the default port for TensorBoard. Start TensorBoard in the container and bind it to 0.0.0.0

```bash
tensorboard --logdir=<path-to-logs> --host=0.0.0.0
```
`--gpus`: Visiable GPUs in container. If you want to specify the GPUs visible to the container, modify the CLI parameters as follows: --gpus "device=0,2".

### Activate Container
Finally, use the following command to enter the container environment, where you can install Python dependencies in the virtual container environment.

```bash
docker attach <Container-name>
```
You can use the Docker plugin in VSCode to connect to a running container, just as you would connect to a remote server (connecting to a container on a server is also permitted).

## Contribution
If you would like to improve the project, you are welcome to submit a PR! :tada:

PS: You need to first fork this project, then create a new branch in your own forked version to make changes. Finally, on the web page, click on Pull Requests -> New Pull Request, select the correct branch, and create the PR.
