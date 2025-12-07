# Implement Plan

You are tasked with implementing an approved technical plan from `thoughts/plans/`. These plans contain phases with specific changes and success criteria.

## Design Philosophy

This command is designed to work across different AI models (Claude, GPT-4, etc.) and organizations. It emphasizes:
- **Deep understanding** before action - read files completely, understand context fully
- **Adaptive execution** - follow the plan's intent while adapting to reality
- **Clear communication** - report mismatches and ask for guidance when needed
- **Systematic verification** - use technology-appropriate commands for validation
- **Forward momentum** - maintain progress while ensuring quality

**Directory Structure:**
This command uses the `thoughts/` directory pattern:
- `thoughts/tickets/` - Original feature requests and task descriptions
- `thoughts/plans/` - Implementation plans (the files you'll be executing)
- `thoughts/research/` - Supporting research and investigation notes

## Getting Started

When given a plan path:
- Read the plan completely and check for any existing checkmarks (- [x])
- Read the original ticket and all files mentioned in the plan
- **Read files fully** - never use limit/offset parameters, you need complete context
- Think deeply about how the pieces fit together
- Create a todo list to track your progress
- Start implementing if you understand what needs to be done

If no plan path provided, ask for one.

## Implementation Philosophy

Plans are carefully designed, but reality can be messy. Your job is to:
- Follow the plan's intent while adapting to what you find
- Implement each phase fully before moving to the next
- Verify your work makes sense in the broader codebase context
- Update checkboxes in the plan as you complete sections

When things don't match the plan exactly, think about why and communicate clearly. The plan is your guide, but your judgment matters too.

If you encounter a mismatch:
- STOP and think deeply about why the plan can't be followed
- Present the issue clearly:
  ```
  Issue in Phase [N]:
  Expected: [what the plan says]
  Found: [actual situation]
  Why this matters: [explanation]

  How should I proceed?
  ```

## Verification Approach

After implementing a phase:

### 1. Run Success Criteria Checks

Use the technology-appropriate commands specified in the plan. Common patterns include:

**Node.js/JavaScript projects:**
- Tests: `npm test` or `npm run test`
- Linting: `npm run lint`
- Type checking: `npm run type-check` or `tsc --noEmit`
- Build: `npm run build`

**Python projects:**
- Tests: `pytest` or `python -m pytest`
- Linting: `black --check .`, `flake8`, or `ruff check`
- Type checking: `mypy .`
- Build: `python -m build`

**Go projects:**
- Tests: `go test ./...`
- Linting: `golangci-lint run`
- Formatting: `gofmt -l .`
- Build: `go build`

**Rust projects:**
- Tests: `cargo test`
- Linting: `cargo clippy`
- Formatting: `cargo fmt --check`
- Build: `cargo build`

**Make-based projects:**
- All-in-one: `make test`, `make lint`, `make build`
- Combined: `make check` (if available)

**Java projects:**
- Tests: `mvn test` or `./gradlew test`
- Build: `mvn package` or `./gradlew build`

### 2. Fix Issues and Update Progress

- Address any failures before moving to the next phase
- Update your progress in both the plan and your todos
- Check off completed items in the plan file itself using the Edit tool

### 3. Batch Verification Strategically

- Don't let verification interrupt your flow unnecessarily
- Batch it at natural stopping points (end of phases or logical sections)
- However, don't skip verification entirely - catch issues early

## If You Get Stuck

When something isn't working as expected:

### 1. Investigate First
- Make sure you've read and understood all relevant code completely (not partially)
- Check if the codebase has evolved since the plan was written
- Look for similar patterns elsewhere in the codebase
- Review error messages and stack traces carefully

### 2. Use Sub-tasks for Targeted Help

Launch Task agents when you need focused assistance:

**Available agent types:**
- **codebase-locator**: Find specific files or components you need
- **codebase-analyzer**: Understand how a specific part of the codebase works
- **explore** (quick/medium/very thorough): Find documentation or examples
- **codebase-pattern-finder**: Find similar implementations to model after

Use sub-tasks sparingly - mainly for targeted debugging or exploring unfamiliar territory.

### 3. Present Issues Clearly

If you encounter a genuine mismatch between the plan and reality, communicate it clearly:

```
Issue in Phase [N]:
Expected: [what the plan says]
Found: [actual situation in codebase]
Why this matters: [impact on implementation]

How should I proceed?
```

Don't guess or assume - ask for clarification when needed.

## Resuming Work

If the plan has existing checkmarks:
- Trust that completed work is done correctly
- Pick up from the first unchecked item
- Verify previous work only if something seems off or doesn't make sense
- Don't re-read or re-implement already completed phases

## Key Principles for Success

### 1. Deep Understanding Before Action
- Read all referenced files COMPLETELY (never use limit/offset parameters)
- Understand how pieces fit together before making changes
- Don't rush into implementation without full context

### 2. Follow Intent, Not Just Instructions
- Plans capture the intended approach, but code evolves
- Use your judgment to adapt to what you actually find
- Stay true to the goal while being flexible with the method

### 3. Maintain Quality
- Run verification commands appropriate to the technology stack
- Fix issues as they arise, don't accumulate technical debt
- Test your changes thoroughly before moving forward

### 4. Communicate Clearly
- Update checkboxes in the plan as you complete sections
- Use the TodoWrite tool to track your implementation progress
- Ask for guidance when you encounter genuine mismatches or ambiguities

### 5. Keep Momentum
- Don't get stuck on minor details - keep making progress
- Batch verification at logical stopping points
- Complete phases fully before moving to the next
- You're implementing a solution, not just checking boxes

## Best Practices

### Working with Plans
- The plan is your guide, not a rigid script
- If reality differs from the plan, adapt intelligently
- Focus on achieving the desired end state
- Keep the overall goal in mind

### Code Quality
- Follow existing codebase patterns and conventions
- Write code that fits naturally with the surrounding context
- Don't introduce new patterns unless the plan explicitly calls for them
- Maintain consistency with the rest of the codebase

### Testing and Verification
- Use the exact commands specified in the plan's success criteria
- If commands aren't specified, use technology-standard commands (see Verification Approach section)
- Run automated tests before manual verification
- Don't skip verification steps - they catch issues early

### Progress Tracking
- Mark checkboxes in the plan file using the Edit tool
- Update your TodoWrite list as you complete tasks
- Provide visibility into your progress
- Celebrate small wins as you complete each phase
