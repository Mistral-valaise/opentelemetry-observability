# Renovate Bot Configuration Fix

## Issue Summary

The Renovate Bot was failing due to multiple configuration validation errors:

### Root Causes Identified

1. **Invalid preset**: `helpers:pinGitHubActionsByDigest` was deprecated/not found
2. **Invalid schedule format**: `"every day"` is not a valid Renovate schedule syntax
3. **Configuration validation errors**: Several packageRules had invalid configurations
4. **Deprecated configurations**: Multiple settings needed migration to new format

### Error Log Analysis

```
ERROR: config-presets-invalid
"validationError": "Cannot find preset's package (helpers:pinGitHubActionsByDigest)"

Configuration Error: Invalid schedule: Failed to parse "every day"
```

## Fixes Applied

### 1. Preset Update

```diff
- "helpers:pinGitHubActionsByDigest"
+ ":pinDigests"
```

### 2. Schedule Format Fix

```diff
- "schedule": ["every day"]
+ "schedule": ["after 2am and before 8am"]
```

### 3. Configuration Migration

- Moved `regexManagers` to `customManagers` with proper format
- Updated `vulnerabilityAlerts` from boolean to object format
- Fixed `helm-values` configuration to use `managerFilePatterns`

### 4. PackageRules Validation

- Fixed all packageRules to use valid schedule formats
- Properly configured custom regex managers with correct datasource templates
- Removed deprecated configuration options

## Verification

### Local Testing

```bash
# Run the configuration test
./test-renovate-config.sh
```

### Manual Trigger

The Renovate workflow can be manually triggered via GitHub Actions:

1. Go to Actions tab
2. Select "🔄 Renovate Bot" workflow
3. Click "Run workflow"
4. Select log level (info/debug)

### Expected Behavior

- No more `config-presets-invalid` errors
- No more schedule parsing errors
- Successful Renovate run with dependency detection
- Proper PR creation for dependency updates

## Configuration Features

The updated configuration includes:

1. **Scheduled Runs**: Daily between 2am-8am Europe/Zurich
2. **Dependency Targets**:
   - Helm chart dependencies
   - OpenTelemetry components
   - Observability stack (Prometheus, Grafana, Jaeger, Tempo)
   - GitHub Actions
   - Docker images in values.yaml
3. **Update Management**:
   - Major updates require manual review
   - Security updates have immediate priority
   - Automerge enabled for GitHub Actions only
4. **Custom Managers**:
   - Regex-based detection for Docker images in Helm values
   - Chart.yaml appVersion updates
   - Custom annotation-based dependency detection

## Files Modified

- `renovate.json` - Fixed configuration
- `test-renovate-config.sh` - Added validation script
- This documentation file

## Testing Status

✅ **Configuration Validation**: Passed  
✅ **JSON Syntax**: Valid  
✅ **Schedule Format**: Valid  
✅ **Preset Resolution**: Valid  
✅ **PackageRules**: All valid  
🔄 **Live Testing**: Ready for manual trigger
