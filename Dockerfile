FROM alpine:latest

ARG MYNAME=sanidoc

ARG TESSDATA_CHECKSUM=d0e3bb6f3b4e75748680524a1d116f2bfb145618f8ceed55b279d15098a530f9
ARG H2ORESTART_CHECKSUM=5db816a1e57b510456633f55e693cb5ef3675ef8b35df4f31c90ab9d4c66071a

# Install dependencies
RUN apk --no-cache -U upgrade && \
    apk --no-cache add \
    ghostscript \
    graphicsmagick \
    libreoffice \
    openjdk8 \
    poppler-utils \
    poppler-data \
    python3 \
    py3-magic \
    tesseract-ocr
#    font-noto-cjk

# Download the trained models from the latest GitHub release of Tesseract, and
# store them under /usr/share/tessdata. This is basically what distro packages
# do under the hood.
#
# Because the GitHub release contains more files than just the trained models,
# we use `find` to fetch only the '*.traineddata' files in the top directory.
#
# Before we untar the models, we also check if the checksum is the expected one.

#RUN mkdir tessdata && cd tessdata \
#    && TESSDATA_VERSION=$(wget -O- -nv https://api.github.com/repos/tesseract-ocr/tessdata_fast/releases/latest \
#        | sed -n 's/^.*"tag_name": "\([0-9.]\+\)".*$/\1/p') \
#    && wget https://github.com/tesseract-ocr/tessdata_fast/archive/$TESSDATA_VERSION/tessdata_fast-$TESSDATA_VERSION.tar.gz \
#    && echo "$TESSDATA_CHECKSUM  tessdata_fast-$TESSDATA_VERSION.tar.gz" | sha256sum -c \
#    && tar -xzvf tessdata_fast-$TESSDATA_VERSION.tar.gz -C . \
#    && find . -name '*.traineddata' -maxdepth 2 -exec cp {} /usr/share/tessdata \; \
#    && cd .. && rm -r tessdata

# Setup the application directories and environment
RUN mkdir -p /opt/$MYNAME
COPY stage1 /opt/$MYNAME/
COPY stage2 /opt/$MYNAME/

RUN adduser -s /bin/sh -D $MYNAME
USER $MYNAME
