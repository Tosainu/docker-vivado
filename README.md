# `Dockerfile` for Vivado

## Usage

1. Download "AMD Unified Installer for FPGAs & Adaptive SoCs 2024.1: Linux Self Extracting Web Installer" `FPGAs_AdaptiveSoCs_Unified_2024.1_0522_2023_Lin64.bin` from the [official download page](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/2024-1.html).
2. Generate `install_config.txt` by the command below. Edit it as needed.

       $ docker build --target configgen --output type=local,dest=. .

3. Create `secret.txt` which contains your AMD account information. The first line shall be your E-mail address. The second line shall be the password.

       email@address
       password

4. Run the command below to build the container image.

       $ docker build --secret id=secret,src=secret.txt -t vivado:v2024.1 .

5. You can start Vivado by the command below.

       $ docker run \
            -it \
            --rm \
            -e "REUID=$UID" \
            -e "REGID=$GID" \
            -e DISPLAY \
            -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
            vivado:v2024.1 \
            /bin/bash -c 'cd && . /opt/Xilinx/Vivado/2024.1/settings64.sh && _JAVA_AWT_WM_NONREPARENTING=1 LD_PRELOAD=/lib/x86_64-linux-gnu/libudev.so.1 vivado'
