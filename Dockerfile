FROM registry.svc.ci.openshift.org/openshift/release:golang-1.10 AS builder

WORKDIR /go/src/github.com/directxman12/k8s-prometheus-adapter
COPY . .
RUN make
RUN mv /go/src/github.com/directxman12/k8s-prometheus-adapter/_output/$(go env GOARCH)/adapter /usr/bin/cm-adapter

FROM registry.svc.ci.openshift.org/openshift/origin-v4.0:base
LABEL io.k8s.display-name="OpenShift Prometheus Custom Metrics Adapter" \
      io.k8s.description="This is a component of OpenShift Container Platform that provides the Kubernetes custom metrics API based on Prometheus metrics" \
      io.openshift.tags="openshift" \
      maintainer="Frederic Branczyk <fbranczy@redhat.com>"

COPY --from=builder /usr/bin/cm-adapter /usr/bin/cm-adapter
    
USER 1001

ENTRYPOINT ["/usr/bin/cm-adapter"]
