# Kubernetes Debug

## Design Philosophy

This command is designed for cross-model compatibility (Claude, GPT-4, etc.) and uses explicit, detailed instructions rather than organization-specific integrations. It helps debug Kubernetes issues during manual testing or implementation by examining resources without editing files. This bootstraps a debugging session without consuming the primary window's context.

You are tasked with helping debug Kubernetes issues during manual testing or
implementation. This command allows you to investigate problems by examining
Kubernetes resources without editing files and live resources. Think of this as
a way to bootstrap a debugging session without using the primary window's
context.

## Initial Response

When invoked WITH a plan/ticket file:
```
I'll help debug issues with [file name]. Let me understand the current state.

What specific problem are you encountering?
- What were you trying to test/implement?
- What went wrong?
- Any error messages?

I'll investigate the logs, database, and git state to help figure out what's happening.
```

When invoked WITHOUT parameters:
```
I'll help debug your current issue.

Please describe what's going wrong:
- What are you working on?
- What specific problem occurred?
- When did it last work?

I can investigate logs, database state, and recent changes to help identify the issue.
```

## Environment Information

You have access to these key locations and tools:

**Kubernetes Resources**:
- Use `kubectl` commands via the Bash tool to interact with the cluster
- Common commands: `get`, `describe`, `logs`, `events`, `top`
- DO NOT read any secrets or sensitive data
- Focus on: Pods, Deployments, Services, ConfigMaps, Ingresses, Events, Resource Quotas, Network Policies

**Git State**:
- Check current branch, recent commits, uncommitted changes
- Similar to how `commit` and `describe_pr` commands work

**Context Files**:
- `thoughts/plans/` - Implementation plans
- `thoughts/tickets/` - Ticket research
- `thoughts/debugging/` - Debug session notes and findings

## Process Steps

### Step 1: Understand the Problem

After the user describes the issue:

1. **Read any provided context** (plan or ticket file):
   - Understand what they're implementing/testing
   - Note which phase or step they're on
   - Identify expected vs actual behavior

2. **Quick state check**:
   - Current git branch and recent commits
   - Any uncommitted changes
   - When the issue started occurring

### Step 2: Investigate the Issue

Use kubectl commands to gather information systematically. Focus on these areas:

**Resource State Investigation**:
```bash
# Find relevant pods/deployments/services
kubectl get pods -n <namespace> --show-labels
kubectl get deployments -n <namespace>
kubectl get services -n <namespace>

# Get detailed resource information
kubectl describe pod <pod-name> -n <namespace>
kubectl describe deployment <deployment-name> -n <namespace>

# Check events for errors
kubectl get events -n <namespace> --sort-by='.lastTimestamp'

# View logs
kubectl logs <pod-name> -n <namespace> --tail=100
kubectl logs <pod-name> -n <namespace> --previous  # Previous container logs if crashed

# Check resource usage
kubectl top pods -n <namespace>
kubectl top nodes
```

**Common Investigation Patterns**:

1. **Pod Issues** - Check pod status, events, describe output, logs
2. **Networking Issues** - Check services, endpoints, ingresses, network policies
3. **Resource Issues** - Check resource quotas, limits, node capacity
4. **Configuration Issues** - Check configmaps, environment variables, volumes
5. **Deployment Issues** - Check rollout status, replica sets, deployment events

**Using Task Agents for Parallel Investigation** (when appropriate):
- Spawn `explore` agent to search codebase for related configuration files
- Spawn `codebase-analyzer` agent to understand deployment manifests or Helm charts
- Use `codebase-locator` to find Kubernetes YAML/manifest files

### Step 3: Present Findings

Based on the investigation, present a focused debug report:

```markdown
## Debug Report

### What's Wrong
[Clear statement of the issue based on evidence]

### Evidence Found

**From Kubernetes Resources**:
- [Error/warning with timestamp]
- [Pattern or repeated issue]

### Root Cause
[Most likely explanation based on evidence]

### Next Steps

1. **Try This First**:
- Update the resource accordingly

### Can't Access?
Some issues might be outside my reach:
- Browser console errors (F12 in browser)
- Cluster control plane issues (requires admin access)
- System-level node issues (SSH access required)
- External dependencies (databases, APIs outside the cluster)

Would you like me to investigate something specific further?
```

### Saving Debug Session

Store your findings in `thoughts/debugging/` for future reference:
- `thoughts/debugging/YYYY-MM-DD-issue-name.md` - Debug session notes
- Include: Problem description, investigation steps, findings, resolution

## Best Practices

### Key Principles for Effective Debugging

1. **Start with the Problem Statement**
   - Always get a clear description of what's wrong before investigating
   - Understand expected vs actual behavior
   - Note when the issue started occurring

2. **Investigate Systematically**
   - Start with pod/deployment status and events
   - Check logs for error messages and stack traces
   - Examine resource usage and limits
   - Review recent configuration changes in git

3. **Look for Patterns**
   - Repeated errors or warnings in logs
   - Timing patterns (does it fail at specific times?)
   - Resource patterns (memory/CPU spikes?)
   - Related pod/service failures

4. **Use Evidence-Based Diagnosis**
   - Base conclusions on actual log entries and events
   - Avoid guessing - if you need more info, gather it
   - Quote relevant error messages in your findings

5. **Provide Actionable Next Steps**
   - Prioritize most likely solutions first
   - Be specific about what to change
   - Suggest verification steps after changes

### When Investigating Kubernetes Issues

- **Check Events First** - Kubernetes events often contain the root cause
- **Read Complete Logs** - Don't just check the last few lines
- **Describe Resources** - The describe output shows conditions and events
- **Check Related Resources** - A pod issue might be caused by service/configmap/secret issues
- **Review Recent Changes** - Check git history for recent manifest changes

### When Reading Context Files

- **Read Completely** - No limit/offset when reading plan/ticket files
- **Understand the Goal** - What were they trying to implement/test?
- **Note the Phase** - Where in the implementation/testing were they?
- **Check Success Criteria** - What should be working?

### When Presenting Findings

- **Be Clear and Specific** - State exactly what's wrong
- **Show Your Evidence** - Include relevant log excerpts and error messages
- **Explain the Root Cause** - Connect the evidence to the problem
- **Prioritize Solutions** - Most likely fix first
- **Know Your Limits** - Be honest about issues outside your reach

## Important Notes

- **Focus on manual testing scenarios** - This is for debugging during implementation
- **Always require problem description** - Can't debug without knowing what's wrong
- **Read files completely** - No limit/offset when reading context
- **Think like `commit` or `describe_pr`** - Understand git state and changes
- **Guide back to user** - Some issues (cluster control plane, external systems) are outside reach
- **No file editing** - Pure investigation only
- **Use kubectl via Bash** - All Kubernetes interaction happens through standard kubectl commands
- **Document findings** - Save debug sessions to `thoughts/debugging/` for future reference

Remember: This command helps you investigate without burning the primary window's context. Perfect for when you hit an issue during manual testing and need to dig into Kubernetes resources, logs, or git state.
