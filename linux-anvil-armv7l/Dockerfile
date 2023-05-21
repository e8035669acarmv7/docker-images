FROM arm32v7/centos:7

ADD qemu-arm-static /usr/bin/qemu-arm-static

LABEL maintainer="conda-forge <conda-forge@googlegroups.com>"

ENV DISTRO_NAME=centos \
    DISTRO_VER=7

# configure yum and rpm for running on armv8l
RUN echo "armhfp" > /etc/yum/vars/basearch && \
    echo "armv7hl" > /etc/yum/vars/arch && \
    echo "armv7hl-redhat-linux-gpu" > /etc/rpm/platform

# location where conda from scatch is installed
ENV CFS_PREFIX /opt/cfs

# Set an encoding to make things work smoothly.
ENV LANG en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

# bust the docker cache so that we always rerun the installs below
ADD https://loripsum.net/api /opt/docker/etc/gibberish

# Resolves a nasty NOKEY warning that appears when using yum.
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-AltArch-Arm32 && \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

COPY scripts/yum_clean_all /opt/docker/bin/
RUN yum update -y && \
    yum reinstall -y glibc-common && \
    /opt/docker/bin/yum_clean_all

RUN localedef -i en_US -f UTF-8 en_US.UTF-8

# Install basic requirements.
RUN yum update -y && \
    yum install -y \
        bzip2 \
        sudo \
        tar \
        patch \
        tmux \
        which && \
    /opt/docker/bin/yum_clean_all

# Run common commands
COPY scripts/run_commands /opt/docker/bin/run_commands
RUN /opt/docker/bin/run_commands

# Download and cache new compiler packages.
# Should speedup installation of them on CIs.
RUN source /opt/conda/etc/profile.d/conda.sh && \
    conda activate && \
    conda create -n test --yes --quiet --download-only \
        e8035669acarmv7::binutils_impl_linux-armv7l \
        e8035669acarmv7::binutils_linux-armv7l \
        e8035669acarmv7::gcc_impl_linux-armv7l \
        e8035669acarmv7::gcc_linux-armv7l \
        e8035669acarmv7::gfortran_impl_linux-armv7l \
        e8035669acarmv7::gfortran_linux-armv7l \
        e8035669acarmv7::gxx_impl_linux-armv7l \
        e8035669acarmv7::gxx_linux-armv7l \
        e8035669acarmv7::libgcc-ng \
        e8035669acarmv7::libgfortran-ng \
        e8035669acarmv7::libstdcxx-ng && \
    conda remove --yes --quiet -n test --all && \
    conda clean -tiy && \
    chgrp -R lucky /opt/conda && \
    chmod -R g=u /opt/conda

# Add a file for users to source to activate the `conda`
# environment `base`. Also add a file that wraps that for
# use with the `ENTRYPOINT`.
COPY linux-anvil-armv7l/entrypoint_source /opt/docker/bin/entrypoint_source
COPY scripts/entrypoint /opt/docker/bin/entrypoint

# Ensure that all containers start with tini and the user selected process.
# Activate the `conda` environment `base` and the devtoolset compiler.
# Provide a default command (`bash`), which will start if the user doesn't specify one.
ENTRYPOINT [ "/opt/conda/bin/tini", "--", "/opt/docker/bin/entrypoint" ]
CMD [ "/bin/bash" ]
