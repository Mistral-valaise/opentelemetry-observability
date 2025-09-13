NAMESPACE ?= opentelemetry-demo
PROFILE ?= charts/opentelemetry-demo/values.yaml

.PHONY: add-repos
add-repos:
	helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
	helm repo add grafana https://grafana.github.io/helm-charts
	-helm repo remove slok || true
	helm repo add sloth https://github.com/slok/sloth
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update

.PHONY: ns
ns:
	kubectl create namespace $(NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -

.PHONY: install-tempo
install-tempo:
	helm upgrade --install tempo grafana/tempo \
		--namespace $(NAMESPACE) \
		--set tempo.persistence.enabled=false \
		--set tempo.storage.trace.backend=local \
		--set tempo.storage.trace.local.path=/var/tempo

.PHONY: install-loki
install-loki:
	helm upgrade --install loki grafana/loki \
		--namespace $(NAMESPACE) \
		--set loki.commonConfig.replication_factor=1 \
		--set loki.storage.type=filesystem \
		--set loki.auth_enabled=false \
		--set loki.useTestSchema=true \
		--set singleBinary.replicas=1 \
		--set write.replicas=0 \
		--set read.replicas=0 \
		--set backend.replicas=0

.PHONY: deps
deps:
	helm dependency build charts/opentelemetry-demo

.PHONY: install-sloth
install-sloth:
	helm upgrade --install sloth sloth/sloth \
		--namespace opentelemetry-demo \
		--set metrics.enabled=false

.PHONY: install-demo
install-demo: deps
	helm upgrade --install otel-demo ./charts/opentelemetry-demo \
		--namespace $(NAMESPACE) \
		-f $(PROFILE)

.PHONY: apply-slos
apply-slos:
	kubectl -n $(NAMESPACE) apply -f values/slo/frontend-availability.yaml
	kubectl -n $(NAMESPACE) apply -f values/slo/frontend-latency.yaml

.PHONY: install-tempo-loki
# Default path keeps embedded Prometheus. For Sloth PrometheusRules and dashboards to have data,
# you can install kube-prometheus-stack and use the overlay values file.
install-tempo-loki: add-repos ns install-loki install-sloth install-demo apply-slos

.PHONY: clean
clean:
	helm -n $(NAMESPACE) uninstall otel-demo loki sloth || true
	kubectl delete namespace $(NAMESPACE) --wait=false || true
