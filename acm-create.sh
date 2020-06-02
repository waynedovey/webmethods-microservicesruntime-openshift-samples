cat <<EOF | oc apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: webmethods
  labels:
    app: webmethods  
---
apiVersion: apps.open-cluster-management.io/v1
kind: Channel
metadata:
  name: webmethods
  namespace: webmethods
  labels:
    app: webmethods
spec:
  type: GitHub
  pathname: https://github.com/waynedovey/webmethods-microservicesruntime-openshift-samples.git
---
apiVersion: apps.open-cluster-management.io/v1
kind: PlacementRule
metadata:
  name: webmethods-dev-clusters
  namespace: webmethods
  labels:
    app: webmethods  
spec:
  clusterConditions:
    - type: OK
  clusterSelector:
    matchExpressions: []
    matchLabels:
      environment: dev
---
apiVersion: app.k8s.io/v1beta1
kind: Application
metadata:
  name: webmethods
  namespace: webmethods
  labels:
    app: webmethods  
spec:
  componentKinds:
  - group: apps.open-cluster-management.io
    kind: Subscription
  descriptor: {}
  selector:
    matchExpressions:
    - key: app
      operator: In
      values:
      - webmethods
---
apiVersion: apps.open-cluster-management.io/v1
kind: Subscription
metadata:
  name: webmethods
  namespace: webmethods
  labels:
    app: webmethods
spec:
  name: webmethods
  channel: webmethods/webmethods
  placement:
    placementRef:
      name: webmethods-dev-clusters
      kind: PlacementRule
      apiGroup: apps.open-cluster-management.io
  packageFilter:
    filterRef:
      name: webmethods
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: webmethods
  namespace: webmethods
  labels:
    app: webmethods
data:
    path: argocd/overlays/cluster1
EOF
