FROM ubuntu:jammy AS base
RUN \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        expect file libgtk2.0-0 libncurses5 libswt-glx-gtk-4-jni libtinfo5 \
        locales python3 x11-utils xz-utils xvfb && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i 's/^#\s*\(en_US.UTF-8\)/\1/' /etc/locale.gen && \
    dpkg-reconfigure --frontend noninteractive locales


FROM base AS installer
ARG INSTALLER_BIN=FPGAs_AdaptiveSoCs_Unified_2024.1_0522_2023_Lin64.bin
COPY --chmod=755 $INSTALLER_BIN /installer.bin
RUN /installer.bin --keep --noexec --target /installer


FROM installer AS do-configgen
ARG INSTALLER_PRODUCT=Vivado
ARG INSTALLER_EDITION="Vivado ML Standard"
RUN /installer/xsetup -b ConfigGen -p "$INSTALLER_PRODUCT" -e "$INSTALLER_EDITION" -l /opt/Xilinx


FROM scratch AS configgen
COPY --from=do-configgen /root/.Xilinx/install_config.txt /


FROM installer AS do-install
ARG INSTALLER_CONFIG=install_config.txt
ARG INSTALLER_AGREED_EULA=XilinxEULA,3rdPartyEULA
COPY auth_token_gen.exp /
COPY $INSTALLER_CONFIG /install_config.txt
COPY --chmod=755 $INSTALLER_BIN /installer.bin
RUN --mount=type=secret,target=/secret.txt,id=secret,required=true \
    expect -f /auth_token_gen.exp /installer/xsetup /secret.txt && \
    /installer/xsetup -b Install -a "$INSTALLER_AGREED_EULA" -c /install_config.txt && \
    rm -rf /opt/Xilinx/.xinstall /opt/Xilinx/Downloads /opt/Xilinx/xic


FROM base
COPY --from=do-install /opt/Xilinx /opt/Xilinx
COPY --chmod=755 entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
