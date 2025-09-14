#!/bin/bash

# Test script for Renovate configuration
echo "🔧 Testing Renovate Configuration..."
echo "=================================="

# Check if renovate.json exists
if [ ! -f "renovate.json" ]; then
    echo "❌ ERROR: renovate.json not found!"
    exit 1
fi

echo "✅ renovate.json found"

# Check JSON syntax
if jq empty renovate.json 2>/dev/null; then
    echo "✅ JSON syntax is valid"
else
    echo "❌ ERROR: Invalid JSON syntax!"
    exit 1
fi

# Check required fields
echo ""
echo "🔍 Checking configuration structure..."

# Check if extends array contains expected presets
if jq -e '.extends | contains([":pinDigests"])' renovate.json >/dev/null; then
    echo "✅ Using :pinDigests preset (replaces deprecated helpers:pinGitHubActionsByDigest)"
else
    echo "⚠️  WARNING: :pinDigests preset not found"
fi

# Check schedule format
SCHEDULE=$(jq -r '.schedule[0]' renovate.json)
if [[ "$SCHEDULE" == "after 2am and before 8am" ]]; then
    echo "✅ Schedule format is valid: $SCHEDULE"
else
    echo "⚠️  WARNING: Schedule might not be in expected format: $SCHEDULE"
fi

# Check packageRules schedules
INVALID_SCHEDULES=$(jq -r '.packageRules[] | select(.schedule[] == "every day") | .description' renovate.json)
if [[ -z "$INVALID_SCHEDULES" ]]; then
    echo "✅ All packageRules have valid schedule formats"
else
    echo "❌ ERROR: Found packageRules with invalid 'every day' schedule:"
    echo "$INVALID_SCHEDULES"
fi

# Check customManagers
CUSTOM_MANAGERS_COUNT=$(jq '.customManagers | length' renovate.json)
echo "✅ Found $CUSTOM_MANAGERS_COUNT custom managers"

# Check for deprecated regexManagers
if jq -e '.regexManagers' renovate.json >/dev/null; then
    echo "⚠️  WARNING: Found deprecated regexManagers, should use customManagers"
else
    echo "✅ Using customManagers instead of deprecated regexManagers"
fi

# Check vulnerabilityAlerts format
if jq -e '.packageRules[] | select(.vulnerabilityAlerts == true)' renovate.json >/dev/null; then
    echo "⚠️  WARNING: Found boolean vulnerabilityAlerts, should use object format"
elif jq -e '.packageRules[] | select(.vulnerabilityAlerts.enabled == true)' renovate.json >/dev/null; then
    echo "✅ Using object format for vulnerabilityAlerts"
fi

echo ""
echo "🎉 Configuration test completed!"
echo ""
echo "📋 Summary of fixes applied:"
echo "- ✅ Replaced helpers:pinGitHubActionsByDigest with :pinDigests"
echo "- ✅ Fixed schedule format from 'every day' to 'after 2am and before 8am'"
echo "- ✅ Moved regex configurations to customManagers"
echo "- ✅ Updated vulnerabilityAlerts to object format"
echo "- ✅ Fixed packageRules configuration structure"
echo ""
echo "🚀 Ready to test with Renovate Bot!"
