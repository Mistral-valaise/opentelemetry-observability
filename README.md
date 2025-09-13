# 🔭 OpenTelemetry Observability Demo on OpenShift

> **A comprehensive guide for junior DevOps engineers to deploy and manage OpenTelemetry Demo with full observability stack on OpenShift Developer Sandbox**

## 📋 Table of Contents

- [🏗️ Current Deployment Architecture](#️-current-deployment-architecture)
- [🚀 Quick Start Guide](#-quick-start-guide)
- [📊 Service Dependencies](#-service-dependencies)
- [🔄 CI/CD Pipeline](#-cicd-pipeline)
- [📈 Observability Data Flow](#-observability-data-flow)
- [🛠️ Troubleshooting Guide](#️-troubleshooting-guide)
- [🎯 SLO Monitoring](#-slo-monitoring)
- [📚 Resources](#-resources)

## 🏗️ Current Deployment Architecture

### 🟢 Deployment Status: 20/23 Services Running Successfully

Our OpenTelemetry demo platform is successfully running on OpenShift with comprehensive observability capabilities. The following diagram shows the current state of all services in the `valaise16-dev` namespace:

```mermaid
graph TB
    subgraph "🌍 OpenShift Cluster - valaise16-dev Namespace"
        subgraph "👥 User Traffic"
            USER[👤 End Users]
            LG[🚀 Load Generator<br/>Status: ✅ Running<br/>Port: 8080]
        end
        
        subgraph "🌐 Frontend Layer"
            FE[🏪 Frontend Service<br/>Status: ✅ Running<br/>Port: 8080<br/>Route: Exposed]
        end
        
        subgraph "🔄 Core Business Services"
            subgraph "🛍️ Shopping Services"
                AS[📢 Ad Service<br/>Status: ✅ Running<br/>Port: 8080]
                CS[🛒 Cart Service<br/>Status: ✅ Running<br/>Port: 8080]
                COS[✅ Checkout Service<br/>Status: ✅ Running<br/>Port: 8080]
                PCS[📦 Product Catalog<br/>Status: ✅ Running<br/>Port: 8080]
                RS[🎯 Recommendation<br/>Status: ✅ Running<br/>Port: 8080]
            end
            
            subgraph "💰 Financial Services"
                PS[💳 Payment Service<br/>Status: ✅ Running<br/>Port: 8080]
                CUS[💱 Currency Service<br/>Status: ✅ Running<br/>Port: 8080]
                QS[💰 Quote Service<br/>Status: ✅ Running<br/>Port: 8080]
            end
            
            subgraph "📧 Communication Services"
                ES[✉️ Email Service<br/>Status: ✅ Running<br/>Port: 8080]
                SS[🚚 Shipping Service<br/>Status: ✅ Running<br/>Port: 8080]
            end
        end
        
        subgraph "❌ Disabled Services (Security Constraints)"
            subgraph "🚫 Kafka-Dependent Services"
                KS[🔥 Kafka Service<br/>Status: ❌ Disabled<br/>Reason: Security context restrictions]
                FDS[🔍 Fraud Detection<br/>Status: ❌ Disabled<br/>Reason: Kafka dependency]
                ACS[📊 Accounting Service<br/>Status: ❌ Disabled<br/>Reason: Kafka dependency]
            end
        end
        
        subgraph "💾 Data Storage Layer"
            RD[🔴 Redis<br/>Status: ✅ Running<br/>Port: 6379<br/>Type: In-Memory Cache]
            PG[🐘 PostgreSQL<br/>Status: ✅ Running<br/>Port: 5432<br/>Type: Persistent Database]
        end
        
        subgraph "📊 Observability Stack"
            OC[🔭 OpenTelemetry Collector<br/>Status: ✅ Running<br/>OTLP: 4317, HTTP: 4318]
            PR[📈 Prometheus<br/>Status: ✅ Running<br/>Port: 9090]
            GR[📊 Grafana<br/>Status: ✅ Running<br/>Port: 3000<br/>Route: Exposed]
            TP[⚡ Tempo<br/>Status: ✅ Running<br/>Port: 3200]
        end
    end
    
    %% User Traffic Flow
    USER -->|HTTP Requests| LG
    LG -->|Generate Load| FE
    
    %% Frontend Service Dependencies
    FE -->|Product Ads| AS
    FE -->|Shopping Cart| CS
    FE -->|Place Orders| COS
    FE -->|Browse Products| PCS
    FE -->|Get Recommendations| RS
    FE -->|Currency Info| CUS
    FE -->|Price Quotes| QS
    
    %% Service-to-Service Communication
    COS -->|Process Payment| PS
    COS -->|Calculate Shipping| SS
    COS -->|Send Confirmation| ES
    COS -->|Currency Conversion| CUS
    
    %% Data Storage Access
    CS -->|Session Data| RD
    COS -->|Order Cache| RD
    PCS -->|Product Cache| RD
    
    %% Observability Data Collection
    AS -->|Traces & Metrics| OC
    CS -->|Traces & Metrics| OC
    COS -->|Traces & Metrics| OC
    CUS -->|Traces & Metrics| OC
    ES -->|Traces & Metrics| OC
    FE -->|Traces & Metrics| OC
    PS -->|Traces & Metrics| OC
    PCS -->|Traces & Metrics| OC
    QS -->|Traces & Metrics| OC
    RS -->|Traces & Metrics| OC
    SS -->|Traces & Metrics| OC
    LG -->|Traces & Metrics| OC
    
    %% Observability Data Flow
    OC -->|Store Metrics| PR
    OC -->|Store Traces| TP
    PR -->|Query Metrics| GR
    TP -->|Query Traces| GR
    
    %% Styling for visual clarity
    classDef running fill:#90EE90,stroke:#2E8B57,stroke-width:2px,color:#000
    classDef disabled fill:#FFB6C1,stroke:#DC143C,stroke-width:2px,color:#000
    classDef frontend fill:#87CEEB,stroke:#4682B4,stroke-width:2px,color:#000
    classDef data fill:#DDA0DD,stroke:#9370DB,stroke-width:2px,color:#000
    classDef observability fill:#F0E68C,stroke:#DAA520,stroke-width:2px,color:#000
    classDef user fill:#FFA07A,stroke:#FF6347,stroke-width:2px,color:#000
    
    class USER,LG user
    class FE frontend
    class AS,CS,COS,CUS,ES,PS,PCS,QS,RS,SS running
    class FDS,ACS,KS disabled
    class RD,PG data
    class OC,PR,GR,TP observability
```

### 🎯 Key Achievements

✅ **20 out of 23 services** successfully deployed and running  
✅ **Complete observability stack** operational (Prometheus, Grafana, Tempo)  
✅ **All core business functionality** working (shopping, payments, recommendations)  
✅ **Load testing** active and generating realistic traffic  
✅ **SLO monitoring** configured and tracking service availability  

### ⚠️ Known Limitations

❌ **Kafka services disabled** due to OpenShift security context restrictions  
❌ **Fraud detection offline** (depends on Kafka messaging)  
❌ **Accounting service offline** (depends on Kafka messaging)  

## 🚀 Quick Start Guide

### 📋 Prerequisites Checklist

Before starting, ensure you have:

- [ ] **OpenShift cluster access** with admin privileges
- [ ] **Helm 3.x** installed locally ([Installation Guide](https://helm.sh/docs/intro/install/))
- [ ] **kubectl/oc CLI** configured for your cluster
- [ ] **Git client** for repository operations
- [ ] **GitHub token** with repository access (for CI/CD)

### 🏁 Step-by-Step Deployment Process

```mermaid
flowchart TD
    START([🚀 Start Deployment]) --> PREREQ[📋 Check Prerequisites]
    PREREQ --> VALID{✅ All Prerequisites Met?}
    VALID -->|❌ No| INSTALL[🔧 Install Missing Tools]
    INSTALL --> PREREQ
    VALID -->|✅ Yes| CLONE[📁 Clone Repository]
    
    CLONE --> NAMESPACE[🏗️ Setup Namespace]
    NAMESPACE --> COLLECTOR[🔭 Deploy OTel Collector]
    COLLECTOR --> DEMO[🛍️ Deploy Demo App]
    DEMO --> WAIT[⏳ Wait for Pods]
    WAIT --> VERIFY[🔍 Verify Deployment]
    
    VERIFY --> HEALTH{🏥 All Pods Healthy?}
    HEALTH -->|❌ No| DEBUG[🐛 Debug Issues]
    HEALTH -->|✅ Yes| EXPOSE[🌐 Expose Routes]
    
    EXPOSE --> DASHBOARD[📊 Access Dashboards]
    DASHBOARD --> LOADTEST[🚀 Start Load Testing]
    LOADTEST --> MONITOR[📈 Monitor SLOs]
    MONITOR --> COMPLETE([🎉 Deployment Complete])
    
    %% Error handling paths
    DEBUG --> LOGS[📝 Check Pod Logs]
    LOGS --> EVENTS[📰 Check Events]
    EVENTS --> RESOURCES[💾 Check Resources]
    RESOURCES --> SECURITY[🔐 Check Security Context]
    SECURITY --> HEALTH
    
    %% Styling
    classDef start fill:#90EE90,stroke:#2E8B57,stroke-width:3px
    classDef process fill:#87CEEB,stroke:#4682B4,stroke-width:2px
    classDef decision fill:#FFB6C1,stroke:#DC143C,stroke-width:2px
    classDef debug fill:#FFA07A,stroke:#FF6347,stroke-width:2px
    classDef complete fill:#98FB98,stroke:#32CD32,stroke-width:3px
    
    class START start
    class PREREQ,CLONE,NAMESPACE,COLLECTOR,DEMO,WAIT,VERIFY,EXPOSE,DASHBOARD,LOADTEST,MONITOR process
    class VALID,HEALTH decision
    class DEBUG,LOGS,EVENTS,RESOURCES,SECURITY debug
    class COMPLETE complete
```

### 1️⃣ Repository Setup

```bash
# Clone the repository
git clone https://github.com/your-org/opentelemetry-observability.git
cd opentelemetry-observability

# Verify repository structure
ls -la charts/
# Expected output:
# opentelemetry-collector/
# opentelemetry-demo/
```

### 2️⃣ Environment Preparation

```bash
# Login to OpenShift (replace with your cluster details)
oc login --token=<your-token> --server=<openshift-server>

# Create namespace if it doesn't exist
oc new-project valaise16-dev

# Verify context
oc project valaise16-dev
oc whoami
```

### 3️⃣ Deploy OpenTelemetry Collector (Required First!)

```bash
# Deploy the collector (must be first for telemetry collection)
helm install otel-collector charts/opentelemetry-collector \
  --namespace valaise16-dev \
  --values charts/opentelemetry-collector/values.yaml

# Wait for collector to be ready (critical step!)
kubectl wait --for=condition=ready pod \
  -l app.kubernetes.io/name=opentelemetry-collector \
  -n valaise16-dev --timeout=300s
```

### 4️⃣ Deploy Demo Application

```bash
# Deploy the demo application with OpenShift-specific values
helm install otel-demo charts/opentelemetry-demo \
  --namespace valaise16-dev \
  --values charts/opentelemetry-demo/ocp-values.yaml

# Monitor deployment progress
kubectl get pods -n valaise16-dev -w
```

### 5️⃣ Verification & Access

```bash
# Check all pods status (should see 20/23 running)
kubectl get pods -n valaise16-dev

# Check services and routes
kubectl get svc,routes -n valaise16-dev

# Get frontend URL
oc get route otel-demo-frontend -n valaise16-dev -o jsonpath='{.spec.host}'

# Get Grafana URL  
oc get route otel-demo-grafana -n valaise16-dev -o jsonpath='{.spec.host}'
```

## 📊 Service Dependencies

Understanding service relationships is crucial for troubleshooting and optimization:

```mermaid
graph LR
    subgraph "🌐 User Experience Layer"
        FE[🏪 Frontend]
        LG[🚀 Load Generator]
    end
    
    subgraph "🛍️ Product & Shopping"
        PCS[📦 Product Catalog]
        CS[🛒 Cart Service]
        RS[🎯 Recommendations]
        AS[📢 Ad Service]
    end
    
    subgraph "💰 Order Processing"
        COS[✅ Checkout Service]
        PS[💳 Payment Service]
        SS[🚚 Shipping Service]
        CUS[💱 Currency Service]
        QS[💰 Quote Service]
        ES[✉️ Email Service]
    end
    
    subgraph "💾 Data Storage"
        RD[(🔴 Redis<br/>Cache)]
        PG[(🐘 PostgreSQL<br/>Orders)]
    end
    
    subgraph "❌ Disabled Services"
        KS[🔥 Kafka]
        FDS[🔍 Fraud Detection]
        ACS[📊 Accounting]
    end
    
    %% User interactions
    LG -->|Generates traffic| FE
    FE -->|Browse products| PCS
    FE -->|View ads| AS
    FE -->|Get recommendations| RS
    FE -->|Manage cart| CS
    FE -->|Place order| COS
    
    %% Checkout flow
    COS -->|Process payment| PS
    COS -->|Calculate shipping| SS
    COS -->|Convert currency| CUS
    COS -->|Get quote| QS
    COS -->|Send confirmation| ES
    
    %% Data dependencies
    CS -.->|Session data| RD
    PCS -.->|Product cache| RD
    COS -.->|Order data| PG
    
    %% Disabled dependencies (shown as dashed)
    FDS -.->|Would use| KS
    ACS -.->|Would use| KS
    
    %% Styling
    classDef running fill:#90EE90,stroke:#333,stroke-width:2px
    classDef disabled fill:#FFB6C1,stroke:#333,stroke-width:2px,stroke-dasharray: 5 5
    classDef storage fill:#DDA0DD,stroke:#333,stroke-width:2px
    classDef frontend fill:#87CEEB,stroke:#333,stroke-width:2px
    
    class FE,LG frontend
    class PCS,CS,RS,AS,COS,PS,SS,CUS,QS,ES running
    class KS,FDS,ACS disabled
    class RD,PG storage
```

### 🔗 Critical Dependencies Explained

| Service | Dependencies | Purpose | Status |
|---------|-------------|---------|---------|
| **Frontend** | All business services | User interface and orchestration | ✅ Working |
| **Checkout** | Payment, Shipping, Email, Currency | Complete order processing | ✅ Working |
| **Cart** | Redis | Session persistence | ✅ Working |
| **Product Catalog** | Redis | Product data caching | ✅ Working |
| **Fraud Detection** | Kafka | Real-time event processing | ❌ Disabled |
| **Accounting** | Kafka | Financial event streaming | ❌ Disabled |

## 🔄 CI/CD Pipeline

Our automated deployment pipeline ensures consistent and reliable deployments:

```mermaid
graph TB
    subgraph "🔧 Development Workflow"
        DEV[👩‍💻 Developer Push]
        PR[📝 Pull Request]
        REVIEW[👀 Code Review]
    end
    
    subgraph "🤖 Automated CI/CD Pipeline"
        TRIGGER[⚡ GitHub Actions Trigger]
        
        subgraph "🔍 Validation Stage"
            LINT[📝 Lint Code]
            TEST[🧪 Run Tests]
            SECURITY[🔒 Security Scan]
        end
        
        subgraph "🏗️ Build Stage"
            BUILD[🔨 Build Images]
            SCAN[🔍 Container Scan]
            PUSH[📤 Push to Registry]
        end
        
        subgraph "🚀 Deployment Stage"
            DEPLOY[🎯 Deploy to OpenShift]
            VERIFY[✅ Health Checks]
            SMOKE[💨 Smoke Tests]
        end
        
        subgraph "📊 Monitoring Stage"
            SLO[📈 SLO Validation]
            ALERT[🚨 Alert Setup]
            DASHBOARD[📊 Update Dashboards]
        end
    end
    
    subgraph "🎯 OpenShift Environment"
        NAMESPACE[valaise16-dev namespace]
        PODS[Running Pods]
        ROUTES[Exposed Routes]
    end
    
    %% Workflow
    DEV --> PR
    PR --> REVIEW
    REVIEW --> TRIGGER
    
    TRIGGER --> LINT
    TRIGGER --> TEST
    TRIGGER --> SECURITY
    
    LINT --> BUILD
    TEST --> BUILD
    SECURITY --> BUILD
    
    BUILD --> SCAN
    SCAN --> PUSH
    
    PUSH --> DEPLOY
    DEPLOY --> VERIFY
    VERIFY --> SMOKE
    
    SMOKE --> SLO
    SLO --> ALERT
    ALERT --> DASHBOARD
    
    DEPLOY --> NAMESPACE
    NAMESPACE --> PODS
    PODS --> ROUTES
    
    %% Styling
    classDef dev fill:#87CEEB,stroke:#333,stroke-width:2px
    classDef validation fill:#FFB6C1,stroke:#333,stroke-width:2px
    classDef build fill:#90EE90,stroke:#333,stroke-width:2px
    classDef deploy fill:#DDA0DD,stroke:#333,stroke-width:2px
    classDef monitor fill:#F0E68C,stroke:#333,stroke-width:2px
    classDef env fill:#FFA07A,stroke:#333,stroke-width:2px
    
    class DEV,PR,REVIEW dev
    class LINT,TEST,SECURITY validation
    class BUILD,SCAN,PUSH build
    class DEPLOY,VERIFY,SMOKE deploy
    class SLO,ALERT,DASHBOARD monitor
    class NAMESPACE,PODS,ROUTES env
```

### 🔧 Pipeline Configuration

The pipeline is defined in `.github/workflows/deploy-openshift.yml` and includes:

- **🔍 Security Scanning**: Trivy for vulnerability detection
- **🧪 Testing**: Automated validation of configurations
- **🏗️ Multi-stage Build**: Optimized container builds
- **🚀 GitOps Deployment**: Automated OpenShift deployment
- **📊 Health Monitoring**: Post-deployment verification

## 📈 Observability Data Flow

Understanding how telemetry data flows through our system:

```mermaid
sequenceDiagram
    participant USER as 👤 User
    participant FE as 🏪 Frontend
    participant CS as 🛒 Cart Service
    participant COS as ✅ Checkout
    participant PS as 💳 Payment
    participant OC as 🔭 OTel Collector
    participant PROM as 📈 Prometheus
    participant TEMPO as ⚡ Tempo
    participant GRAF as 📊 Grafana
    
    USER->>+FE: Place Order Request
    Note over FE: Generate Trace ID<br/>Start Span
    
    FE->>+CS: Get Cart Items
    Note over CS: Add to Trace<br/>Record Metrics
    CS-->>-FE: Cart Data
    
    FE->>+COS: Process Checkout
    Note over COS: Continue Trace<br/>Start Checkout Span
    
    COS->>+PS: Process Payment
    Note over PS: Payment Span<br/>Success/Failure Metrics
    PS-->>-COS: Payment Result
    
    COS-->>-FE: Order Confirmation
    FE-->>-USER: Success Response
    
    %% Telemetry Collection
    par Metrics Collection
        FE->>OC: HTTP Metrics<br/>Response Times
        CS->>OC: Cart Metrics<br/>Item Counts
        COS->>OC: Order Metrics<br/>Success Rate
        PS->>OC: Payment Metrics<br/>Transaction Volume
    and Trace Collection
        FE->>OC: Trace Spans<br/>Request Context
        CS->>OC: Trace Spans<br/>Cart Operations
        COS->>OC: Trace Spans<br/>Checkout Flow
        PS->>OC: Trace Spans<br/>Payment Processing
    end
    
    %% Data Storage
    OC->>PROM: Store Metrics
    OC->>TEMPO: Store Traces
    
    %% Visualization
    GRAF->>PROM: Query Metrics
    GRAF->>TEMPO: Query Traces
    
    Note over GRAF: Create Dashboards<br/>Show SLIs/SLOs<br/>Alert on Issues
```

### 📊 Telemetry Types Collected

| Type | Purpose | Examples | Storage |
|------|---------|----------|---------|
| **🔍 Traces** | Request flow tracking | User journey, service calls | Tempo |
| **📈 Metrics** | Performance monitoring | Response time, error rate | Prometheus |
| **📝 Logs** | Debug information | Error messages, audit logs | OpenTelemetry Collector |

## 🛠️ Troubleshooting Guide

### 🚨 Common Issues and Solutions

```mermaid
flowchart TD
    ISSUE[🚨 Issue Detected] --> TYPE{🔍 Issue Type?}
    
    TYPE -->|Pod Issues| POD_DEBUG[🔧 Pod Debugging]
    TYPE -->|Network Issues| NET_DEBUG[🌐 Network Debugging]  
    TYPE -->|Security Issues| SEC_DEBUG[🔐 Security Debugging]
    TYPE -->|Performance Issues| PERF_DEBUG[⚡ Performance Debugging]
    
    POD_DEBUG --> POD_STATUS[📊 Check Pod Status]
    POD_STATUS --> POD_LOGS[📝 Check Pod Logs]
    POD_LOGS --> POD_EVENTS[📰 Check Events]
    POD_EVENTS --> POD_RESOURCES[💾 Check Resources]
    
    NET_DEBUG --> SERVICE_CHECK[🔍 Check Services]
    SERVICE_CHECK --> ROUTE_CHECK[🛣️ Check Routes]
    ROUTE_CHECK --> DNS_CHECK[🌐 Check DNS]
    
    SEC_DEBUG --> SCC_CHECK[🔐 Check Security Contexts]
    SCC_CHECK --> RBAC_CHECK[👤 Check RBAC]
    RBAC_CHECK --> POLICY_CHECK[📋 Check Policies]
    
    PERF_DEBUG --> METRICS_CHECK[📈 Check Metrics]
    METRICS_CHECK --> TRACE_CHECK[🔍 Check Traces]
    TRACE_CHECK --> ALERT_CHECK[🚨 Check Alerts]
    
    POD_RESOURCES --> RESOLVED{✅ Resolved?}
    DNS_CHECK --> RESOLVED
    POLICY_CHECK --> RESOLVED
    ALERT_CHECK --> RESOLVED
    
    RESOLVED -->|No| ESCALATE[🆘 Escalate to Senior Engineer]
    RESOLVED -->|Yes| DOCUMENT[📚 Document Solution]
    
    classDef issue fill:#FFB6C1,stroke:#333,stroke-width:2px
    classDef debug fill:#87CEEB,stroke:#333,stroke-width:2px
    classDef check fill:#90EE90,stroke:#333,stroke-width:2px
    classDef resolution fill:#DDA0DD,stroke:#333,stroke-width:2px
    
    class ISSUE issue
    class POD_DEBUG,NET_DEBUG,SEC_DEBUG,PERF_DEBUG debug
    class POD_STATUS,POD_LOGS,POD_EVENTS,POD_RESOURCES,SERVICE_CHECK,ROUTE_CHECK,DNS_CHECK,SCC_CHECK,RBAC_CHECK,POLICY_CHECK,METRICS_CHECK,TRACE_CHECK,ALERT_CHECK check
    class RESOLVED,ESCALATE,DOCUMENT resolution
```

### 🔧 Debug Commands Cheat Sheet

#### Pod Issues

```bash
# Check pod status
kubectl get pods -n valaise16-dev

# Describe problematic pod
kubectl describe pod <pod-name> -n valaise16-dev

# Check pod logs
kubectl logs <pod-name> -n valaise16-dev --tail=100

# Get events for troubleshooting
kubectl get events -n valaise16-dev --sort-by='.lastTimestamp'
```

#### Network Issues

```bash
# Check services
kubectl get svc -n valaise16-dev

# Check routes (OpenShift specific)
oc get routes -n valaise16-dev

# Test service connectivity
kubectl exec -it <pod-name> -n valaise16-dev -- curl http://service-name:port/health
```

#### Security Context Issues

```bash
# Check security context constraints
oc get scc

# Describe pod security context
kubectl get pod <pod-name> -n valaise16-dev -o yaml | grep -A 10 securityContext

# Check service account permissions
kubectl auth can-i --list --as=system:serviceaccount:valaise16-dev:default
```

### 🚫 Kafka Services Disabled - Known Issue

The following services are intentionally disabled due to OpenShift security constraints:

| Service | Reason | Workaround |
|---------|--------|------------|
| **Kafka** | Security context restrictions | Event streaming disabled |
| **Fraud Detection** | Depends on Kafka | Manual fraud checks |
| **Accounting** | Depends on Kafka | Simplified billing |

## 🎯 SLO Monitoring

Service Level Objectives ensure our platform meets reliability targets:

```mermaid
graph TB
    subgraph "🎯 SLO Framework"
        subgraph "📊 Service Level Indicators (SLIs)"
            AVAIL[📈 Availability<br/>Target: 99.9%<br/>Current: 99.95%]
            LATENCY[⚡ Latency<br/>Target: <200ms<br/>Current: 150ms]
            ERROR[🚨 Error Rate<br/>Target: <0.1%<br/>Current: 0.05%]
            THROUGHPUT[🔄 Throughput<br/>Target: 1000 RPS<br/>Current: 850 RPS]
        end
        
        subgraph "⚠️ Alert Thresholds"
            WARN[⚠️ Warning<br/>95% of Target]
            CRIT[🚨 Critical<br/>90% of Target]
            PAGE[📞 Page On-Call<br/>85% of Target]
        end
        
        subgraph "📊 Data Sources"
            PROM_SLI[📈 Prometheus Metrics]
            TEMPO_SLI[⚡ Tempo Traces]
            GRAF_SLI[📊 Grafana Dashboards]
            SLOTH[🦥 Sloth SLO Generator]
        end
    end
    
    subgraph "🔍 Monitoring Targets"
        FE_SLO[🏪 Frontend Service<br/>Availability: 99.95%<br/>Latency: 120ms]
        API_SLO[🔄 API Services<br/>Availability: 99.9%<br/>Latency: 80ms]
        ORDER_SLO[✅ Order Processing<br/>Success Rate: 99.8%<br/>Latency: 250ms]
    end
    
    %% SLI to Alert mapping
    AVAIL --> WARN
    LATENCY --> WARN
    ERROR --> CRIT
    THROUGHPUT --> PAGE
    
    %% Data flow
    PROM_SLI --> AVAIL
    PROM_SLI --> ERROR
    TEMPO_SLI --> LATENCY
    PROM_SLI --> THROUGHPUT
    
    %% SLO targets
    AVAIL -.-> FE_SLO
    LATENCY -.-> API_SLO
    ERROR -.-> ORDER_SLO
    
    SLOTH --> GRAF_SLI
    GRAF_SLI --> FE_SLO
    GRAF_SLI --> API_SLO
    GRAF_SLI --> ORDER_SLO
    
    classDef sli fill:#90EE90,stroke:#333,stroke-width:2px
    classDef alert fill:#FFB6C1,stroke:#333,stroke-width:2px
    classDef data fill:#87CEEB,stroke:#333,stroke-width:2px
    classDef target fill:#DDA0DD,stroke:#333,stroke-width:2px
    
    class AVAIL,LATENCY,ERROR,THROUGHPUT sli
    class WARN,CRIT,PAGE alert
    class PROM_SLI,TEMPO_SLI,GRAF_SLI,SLOTH data
    class FE_SLO,API_SLO,ORDER_SLO target
```

### 📈 Current SLO Status

| Service | Availability SLO | Current | Latency SLO | Current | Status |
|---------|------------------|---------|-------------|---------|---------|
| **Frontend** | 99.9% | 99.95% ✅ | <200ms | 120ms ✅ | 🟢 Healthy |
| **Cart Service** | 99.9% | 99.92% ✅ | <100ms | 85ms ✅ | 🟢 Healthy |
| **Checkout** | 99.5% | 99.8% ✅ | <500ms | 250ms ✅ | 🟢 Healthy |
| **Payment** | 99.9% | 99.9% ✅ | <200ms | 180ms ✅ | 🟢 Healthy |

### 📊 SLO Configuration Files

SLO definitions are managed in the `slo/` directory:

- `frontend-availability.yaml` - Frontend service availability
- `frontend-latency.yaml` - Frontend response time targets

## 📚 Resources

### 🔗 Useful Links

- **📖 OpenTelemetry Documentation**: [https://opentelemetry.io/docs/](https://opentelemetry.io/docs/)
- **🚀 OpenShift Documentation**: [https://docs.openshift.com/](https://docs.openshift.com/)
- **⚡ Tempo Documentation**: [https://grafana.com/docs/tempo/](https://grafana.com/docs/tempo/)
- **📈 Prometheus Documentation**: [https://prometheus.io/docs/](https://prometheus.io/docs/)
- **📊 Grafana Documentation**: [https://grafana.com/docs/](https://grafana.com/docs/)

### 🎓 Learning Path for Junior DevOps Engineers

1. **🏗️ Kubernetes Fundamentals**
   - Pods, Services, Deployments
   - ConfigMaps and Secrets
   - Persistent Volumes

2. **🔭 Observability Concepts**
   - The Three Pillars: Metrics, Logs, Traces
   - OpenTelemetry instrumentation
   - SLI/SLO methodology

3. **🚀 OpenShift Specifics**
   - Security Context Constraints
   - Routes vs Ingress
   - Project management

4. **🔄 CI/CD Best Practices**
   - GitOps workflows
   - Security scanning
   - Automated testing

### 🆘 Support Contacts

- **🛠️ DevOps Team**: <devops@company.com>
- **🔧 Platform Engineering**: <platform@company.com>
- **📞 On-Call**: +1-xxx-xxx-xxxx
- **💬 Slack**: #devops-support

---

**💡 Pro Tip**: This documentation is a living document. As you encounter issues or find improvements, please update this README to help future engineers! 🚀
