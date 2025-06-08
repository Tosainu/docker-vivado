# `Dockerfile` for Vivado

## Build cotainer images

### Using Bake

1. Download "AMD Unified Installer for FPGAs & Adaptive SoCs : Linux Self Extracting Web Installer" from the [official download page](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools.html).
2. Generate `install_config.txt` by the command below. You will see the files in the directory `config/<version>/`. Edit them it as needed.

       $ docker buildx bake config-2023_2  # for Vivado 2023.2

       $ docker buildx bake config-2024_1  # for Vivado 2024.1

       $ docker buildx bake config-2024_2  # for Vivado 2024.2

       $ docker buildx bake config-2025_1  # for Vivado 2025.1

       $ docker buildx bake config-all  # for all available versions

3. Create `secret.txt` which contains your AMD account information. The first line shall be your E-mail address. The second line shall be the password.

       email@address
       password

4. Run the command below to build the container image.

       $ docker buildx bake --load build-2023_2  # for Vivado 2023.2

       $ docker buildx bake --load build-2024_1  # for Vivado 2024.1

       $ docker buildx bake --load build-2024_2  # for Vivado 2024.2

       $ docker buildx bake --load build-2025_1  # for Vivado 2025.1

       $ docker buildx bake --load build-all  # for all available versions

### Using basic Docker Build commands

1. Download "AMD Unified Installer for FPGAs & Adaptive SoCs : Linux Self Extracting Web Installer" from the [official download page](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools.html).
2. Generate `install_config.txt` by the command below, where `<filename>` is the filename of the installer downloaded in the first step. Edit `install_config.txt` it as needed.

       $ docker build --build-arg INSTALLER_BIN=<filename> --target configgen --output type=local,dest=. .

3. Create `secret.txt` which contains your AMD account information. The first line shall be your E-mail address. The second line shall be the password.

       email@address
       password

4. Run the command below to build the container image, where `<filename>` is the filename of the installer downloaded in the first step.

       $ docker build --build-arg INSTALLER_BIN=<filename> --secret id=secret,src=secret.txt -t vivado:v2024.1 .

## Usage

Assuming you built the container image `vivado:v2024.1`, you can start Vivado by:

    $ docker run \
        -it \
        --rm \
        -e "REUID=$UID" \
        -e "REGID=$GID" \
        -e DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
        vivado:v2024.1 \
        /bin/bash -c 'cd && . /opt/Xilinx/Vivado/2024.1/settings64.sh && _JAVA_AWT_WM_NONREPARENTING=1 LD_PRELOAD=/lib/x86_64-linux-gnu/libudev.so.1 vivado'

Apparently, they changed the directory structure as of 2025.1. To start Vivado 2025.1 in the same way as above:

    $ docker run \
        -it \
        --rm \
        -e "REUID=$UID" \
        -e "REGID=$GID" \
        -e DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
        vivado:v2025.1 \
        /bin/bash -c 'cd && . /opt/Xilinx/2025.1/Vivado/settings64.sh && _JAVA_AWT_WM_NONREPARENTING=1 LD_PRELOAD=/lib/x86_64-linux-gnu/libudev.so.1 vivado'
