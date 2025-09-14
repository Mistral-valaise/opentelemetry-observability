# 🔭 OpenTelemetry Observability Demo (OpenShift)

Short, practical guide for junior DevOps to deploy, observe, and maintain the OTel Demo on OpenShift.

## 🚀 Quick start

Prereqs: OpenShift access, Helm 3.14+, oc CLI.

```bash
# Project + SA (OpenShift)
oc new-project opentelemetry-demo
oc create sa opentelemetry-demo
oc adm policy add-scc-to-user anyuid -z opentelemetry-demo
oc adm policy add-scc-to-user privileged -z opentelemetry-demo
oc adm policy add-role-to-user view -z opentelemetry-demo

# Install
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update
helm install otel-demo charts/opentelemetry-demo \
  --namespace opentelemetry-demo \
  --values charts/opentelemetry-demo/ocp-values.yaml \
  --set serviceAccount.create=false \
  --set serviceAccount.name=opentelemetry-demo
```

Access after port-forward: Web <http://localhost:8080/>, Grafana /grafana, Jaeger /jaeger/ui, Loadgen /loadgen.

## 🧠 What’s inside (high level)

```mermaid
flowchart LR
  subgraph App Services
    FE[Frontend] -->|HTTP/gRPC| OC((OTel Collector))
    SVC1[Cart] --> OC
    SVC2[Checkout] --> OC
    SVC3[Product Catalog] --> OC
    SVC4[Payment] --> OC
    SVC5[Recommendation] --> OC
  end

  OC -->|Traces (OTLP gRPC)| TEMPO[Tempo]
  OC -->|Metrics (OTLP/Prom)| PROM[Prometheus]
  PROM -->|Dashboards| GRAF[Grafana]
  TEMPO -->|Traces| GRAF
```

Key chart pieces in `charts/opentelemetry-demo/Chart.yaml` (auto-updated by Renovate):

- opentelemetry-collector 0.130.1
- tempo 1.23.3
- jaeger 3.4.1 (disabled by default here)
- prometheus 27.30.0
- grafana 9.3.2
- opensearch 2.35.0 (disabled by default)

OpenShift values live in `charts/opentelemetry-demo/ocp-values.yaml`.

## 🔧 Collector essentials (junior-friendly)

Where: `opentelemetry-collector.config` in `ocp-values.yaml`.

- Receivers: how telemetry arrives
  - otlp (4317 gRPC, 4318 HTTP), httpcheck (pings frontend-proxy), redis
- Processors: mutate/shape data
  - memory_limiter, resource (add k8s attrs), transform (normalize span names)
- Connectors: generate extra metrics
  - spanmetrics (request rate/latency/errors), servicegraph (service map)
- Exporters: where data goes
  - otlp -> Tempo (traces), otlphttp/prometheus -> Prometheus (metrics)

Pipelines:

- traces: receivers [otlp] -> processors [memory_limiter, resource, transform, batch] -> exporters [otlp, debug, spanmetrics, servicegraph]
- metrics: receivers [httpcheck, redis, otlp, spanmetrics, servicegraph] -> processors [memory_limiter, resource, batch] -> exporters [otlphttp/prometheus, debug]
- logs: receivers [otlp] -> processors [memory_limiter, resource, batch] -> exporters [debug]

Tuning tips:

- Low memory? Increase memory_limiter percentages or reduce replicas.
- Not seeing traces? Check app envs point to Collector 4317/4318.
- Want service map? Keep servicegraph connector and Grafana-Tempo configured.

## 📊 SLO-driven monitoring

Prometheus rules (in `ocp-values.yaml`) use spanmetrics to build SLIs/SLOs for the frontend:

- Availability: 5xx ratio over requests
- Latency: 250ms threshold ratio

Dashboards (Grafana): demo, collector, spanmetrics, exemplars. Tempo enables traces-to-metrics and service map.

## 🔄 Automated updates (Renovate)

This repo runs daily scans (2–8am Europe/Zurich) and opens PRs when new versions exist for:

- Helm charts in `Chart.yaml` (helmv3)
- Images in `values.yaml` files (helm-values)
- Vendored subchart archives under `charts/` (auto-refreshed)
- GitHub Actions

See `renovate.json`. Dependency Dashboard issue is enabled.

## 🛠️ Handy ops commands

```bash
# Status & logs
oc get pods -n opentelemetry-demo
oc logs deploy/otel-collector -n opentelemetry-demo

# Collector metrics (prometheus internal)
oc port-forward svc/otel-collector 8889:8889 -n opentelemetry-demo &
curl -s http://localhost:8889/metrics | grep -E 'receiver_accepted|exporter_sent'

# Upgrade with your changes
helm upgrade otel-demo charts/opentelemetry-demo \
  -n opentelemetry-demo \
  -f charts/opentelemetry-demo/ocp-values.yaml
```

## 📚 Pointers

- OpenTelemetry Demo: <https://opentelemetry.io/docs/demo/>
- OTel Helm: <https://github.com/open-telemetry/opentelemetry-helm-charts>
- OpenShift Docs: <https://docs.openshift.com/>
