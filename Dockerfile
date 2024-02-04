FROM arm32v7/debian:bookworm AS build-qt
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
RUN apt-get update \
    && apt-get install -y build-essential ninja-build generate-ninja libts-dev wget python3 cmake libdrm-dev libgles2-mesa-dev
WORKDIR /root
RUN wget --progress=dot:giga https://download.qt.io/official_releases/qt/6.5/6.5.3/single/qt-everywhere-src-6.5.3.tar.xz \
    && tar xf ./qt-everywhere-src-6.5.3.tar.xz
RUN ./qt-everywhere-src-6.5.3/configure -prefix /usr/local/Qt6 \
    && cmake --build . --parallel \
    && cmake --install .

FROM arm32v7/debian:bookworm
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
RUN apt-get update \
    && apt-get install -y build-essential libts-dev libdrm-dev libgles2-mesa-dev
COPY --from=build-qt /usr/local/Qt6 /usr/local/Qt6
ENV PATH="${PATH}:/usr/local/Qt6/bin"
