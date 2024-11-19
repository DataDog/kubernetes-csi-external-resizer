ARG BASE_IMAGE
ARG BUILDER_IMAGE

FROM $BUILDER_IMAGE AS builder
WORKDIR /go/src/kubernetes-csi/external-resizer
ADD . .
ENV GOTOOLCHAIN auto
ENV GOFLAGS="-buildvcs=false"
RUN make build

FROM $BASE_IMAGE
LABEL maintainers="Compute"
LABEL description="CSI External Resizer"
ARG binary=./bin/csi-resizer

COPY --from=builder /go/src/kubernetes-csi/external-resizer/${binary} csi-resizer
ENTRYPOINT ["/csi-resizer"]
