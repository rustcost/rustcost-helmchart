# RustCost Helm Chart

**Info · Chart Setup · Publishing · Releases · Downloads · Hub**

---

## Maintainer

- @songk1992

---

## How to Use

You’ll need [Helm](https://helm.sh/docs/) installed before using this chart.

Add the repository:

```bash
helm repo add rustcost https://rustcost.github.io/rustcost-helmchart
```

Installation details can be found in the [chart guide](https://rustcost.github.io/rustcost-helm-chart).

---

## Running Tests

You can optionally validate the chart with **helm-unittest**.

Install the plugin:

```bash
helm plugin install https://github.com/helm-unittest/helm-unittest
```

Run tests from the repository root:

```bash
helm unittest charts/rustcost
```

Expected output example:

```
### Chart [ rustcost ] charts/rustcost

 PASS  deployment test            charts/rustcost/tests/deployment_test.yaml
 PASS  snapshot test              charts/rustcost/tests/rustcost_test.yaml

Charts:      1 of 1 passed
Suites:      2 of 2 passed
Tests:       2 of 2 passed
Snapshots:   1 of 1 passed
Time:        29ms
```

---

Example Installs

1. Basic install with bundled Postgres
   mkdir rustcost-chart && cd rustcost-chart

# create chart files in the right structure

helm dependency update ./rustcost-chart # not required now, but good practice
helm install rustcost ./rustcost-chart --create-namespace --namespace rustcost

2. Using an external Postgres

Disable the bundled database and provide your own connection string:

```
helm install rustcost ./rustcost-chart \
 --namespace rustcost --create-namespace \
 --set postgres.enable=false \
 --set externalDatabase.enabled=true \
 --set externalDatabase.url="postgres://id:pwd@127.0.0.1:35001/rustcost" \
 --set app.port="5000" \
 --set app.host="127.0.0.1"
```

3. Integrating with Prometheus (recommended)

Point the app to an existing Prometheus in your cluster:

```
helm install rustcost ./rustcost-chart \
 --namespace rustcost --create-namespace \
 --set metrics.prometheus.enabled=true \
 --set metrics.prometheus.url="http://prometheus-k8s.monitoring.svc:9090"
```

This sets PROMETHEUS_URL in the pod. Your app can query node metrics with PromQL (e.g., node_cpu_seconds_total, node_memory_MemAvailable_bytes).

4. Prometheus Operator with ServiceMonitor

If you run Prometheus Operator, enable a ServiceMonitor so Prometheus scrapes node-exporter:

```
helm install rustcost ./rustcost-chart \
 --set metrics.prometheusServiceMonitor.enabled=true \
 --set metrics.prometheusServiceMonitor.namespace=monitoring
```

5. Deploying node-exporter via this chart (optional)

Not recommended if you already run node-exporter cluster-wide:

```
helm install rustcost ./rustcost-chart \
 --set nodeExporter.deploy=true \
 --set metrics.prometheusServiceMonitor.enabled=true \
 --set metrics.prometheusServiceMonitor.namespace=monitoring
```

---

## Related Resources

- [RustCost Project](https://github.com/orgs/rustcost)
