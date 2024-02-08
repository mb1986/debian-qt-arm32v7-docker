ARG DEBIAN_VER=bookworm
FROM arm32v7/debian:$DEBIAN_VER AS build-qt
ARG QT_VER_MAJOR=6
ARG QT_VER_MINOR=5
ARG QT_VER_PATCH=3
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
RUN apt-get -q update \
    && apt-get -q install -y build-essential ninja-build generate-ninja libts-dev wget python3 cmake libdrm-dev libgles2-mesa-dev
WORKDIR /root
RUN wget --progress=dot:giga https://download.qt.io/official_releases/qt/$QT_VER_MAJOR.$QT_VER_MINOR/$QT_VER_MAJOR.$QT_VER_MINOR.$QT_VER_PATCH/single/qt-everywhere-src-$QT_VER_MAJOR.$QT_VER_MINOR.$QT_VER_PATCH.tar.xz \
    && tar xf ./qt-everywhere-src-$QT_VER_MAJOR.$QT_VER_MINOR.$QT_VER_PATCH.tar.xz
RUN ./qt-everywhere-src-$QT_VER_MAJOR.$QT_VER_MINOR.$QT_VER_PATCH/configure -prefix /usr/local/Qt$QT_VER_MAJOR \
    && cmake --build . --parallel \
    && cmake --install .

FROM arm32v7/debian:$DEBIAN_VER
ARG QT_VER_MAJOR=6
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
RUN apt-get update -q \
    && apt-get -q install -y build-essential libts-dev libdrm-dev libgles2-mesa-dev
COPY --from=build-qt /usr/local/Qt$QT_VER_MAJOR /usr/local/Qt$QT_VER_MAJOR
ENV PATH="${PATH}:/usr/local/Qt$QT_VER_MAJOR/bin"
