# Validate Plan

You are tasked with validating that an implementation plan was correctly executed, verifying all success criteria and identifying any deviations or issues.

## Design Philosophy

This command is designed to work across different AI models (Claude, GPT-4, etc.) and technology stacks. It uses:
- **Generic agents**: `codebase-analyzer`, `codebase-locator`, `explore` for discovering implementation details
- **Technology-agnostic verification**: Adapts to project-specific build/test commands
- **thoughts/ directory pattern**: Generic storage for plans and validation reports (`thoughts/plans/`, `thoughts/validation/`)
- **Explicit, structured instructions**: Clear steps that any model can follow
- **Comprehensive examples**: Demonstrates expected validation depth and format

## Initial Setup

When invoked:
1. **Determine context** - Are you in an existing conversation or starting fresh?
   - If existing: Review what was implemented in this session
   - If fresh: Need to discover what was done through git and codebase analysis

2. **Locate the plan**:
   - If plan path provided, use it
   - Otherwise, search `thoughts/plans/` directory for recent plans
   - Check recent commits for plan references: `git log --grep="plan" --oneline -n 20`
   - Ask user if plan location unclear

3. **Gather implementation evidence**:
   ```bash
   # Check recent commits
   git log --oneline -n 20
   git diff HEAD~N..HEAD  # Where N covers implementation commits
   ```

4. **Determine verification approach** based on technology stack:
   
   **Node.js/TypeScript projects**:
   ```bash
   npm run build          # or: yarn build, pnpm build
   npm run test           # or: yarn test, pnpm test
   npm run lint           # or: yarn lint, pnpm lint
   npm run typecheck      # TypeScript type checking
   ```
   
   **Python projects**:
   ```bash
   pytest                 # or: python -m pytest
   mypy .                 # Type checking
   ruff check .           # or: flake8, pylint
   python -m build        # Package building
   ```
   
   **Go projects**:
   ```bash
   go build ./...
   go test ./...
   go vet ./...
   golangci-lint run      # if available
   ```
   
   **Rust projects**:
   ```bash
   cargo build
   cargo test
   cargo clippy           # Linting
   cargo fmt --check      # Format checking
   ```
   
   **Java/Maven projects**:
   ```bash
   mvn clean verify
   mvn test
   mvn checkstyle:check   # if configured
   ```
   
   **Make-based projects**:
   ```bash
   make check test        # or: make verify, make all
   ```
   
   **Always check project files** (`package.json`, `Makefile`, `pyproject.toml`, etc.) for available verification commands before running them.

## Validation Process

### Step 1: Context Discovery

If starting fresh or need more context:

1. **Read the implementation plan** completely
2. **Identify what should have changed**:
   - List all files that should be modified
   - Note all success criteria (automated and manual)
   - Identify key functionality to verify

3. **Spawn parallel research tasks** to discover implementation using generic agents:
   
   **Use `codebase-analyzer` agent** for detailed implementation analysis:
   ```
   Task 1 - Verify database changes:
   Use codebase-analyzer to research if migration [N] was added and schema changes match plan.
   Check: migration files, schema version, table structure
   Return: What was implemented vs what plan specified
   ```
   
   **Use `codebase-locator` agent** to find modified files:
   ```
   Task 2 - Verify code changes:
   Use codebase-locator to find all modified files related to [feature].
   Compare actual changes to plan specifications.
   Return: File-by-file comparison of planned vs actual
   ```
   
   **Use `explore` agent** for test coverage verification:
   ```
   Task 3 - Verify test coverage:
   Use explore agent to check if tests were added/modified as specified.
   Return: Test file locations, test status, and any missing coverage
   ```

### Step 2: Systematic Validation

For each phase in the plan:

1. **Check completion status**:
   - Look for checkmarks in the plan (- [x])
   - Verify the actual code matches claimed completion

2. **Run automated verification**:
   - Execute each command from "Automated Verification"
   - Document pass/fail status
   - If failures, investigate root cause

3. **Assess manual criteria**:
   - List what needs manual testing
   - Provide clear steps for user verification

4. **Think deeply about edge cases**:
   - Were error conditions handled?
   - Are there missing validations?
   - Could the implementation break existing functionality?

### Step 3: Generate Validation Report

Create comprehensive validation summary:

```markdown
## Validation Report: [Plan Name]

### Implementation Status
✓ Phase 1: [Name] - Fully implemented
✓ Phase 2: [Name] - Fully implemented
⚠️ Phase 3: [Name] - Partially implemented (see issues)

### Automated Verification Results
✓ Build passes: `npm run build`
✓ Tests pass: `npm test` (42 tests, 0 failures)
✓ Type checking: `npm run typecheck` (0 errors)
⚠️ Linting issues: `npm run lint` (3 warnings in src/utils/helper.ts)

### Code Review Findings

#### Matches Plan:
- Database migration correctly adds [table]
- API endpoints implement specified methods
- Error handling follows plan

#### Deviations from Plan:
- Used different variable names in [file:line]
- Added extra validation in [file:line] (improvement)

#### Potential Issues:
- Missing index on foreign key could impact performance
- No rollback handling in migration

### Manual Testing Required:
1. UI functionality:
   - [ ] Verify [feature] appears correctly
   - [ ] Test error states with invalid input

2. Integration:
   - [ ] Confirm works with existing [component]
   - [ ] Check performance with large datasets

### Recommendations:
- Address linting warnings before merge
- Consider adding integration test for [scenario]
- Document new API endpoints
```

## Working with Existing Context

If you were part of the implementation:
- Review the conversation history
- Check your todo list for what was completed
- Focus validation on work done in this session
- Be honest about any shortcuts or incomplete items

## Important Guidelines

1. **Be thorough but practical** - Focus on what matters
2. **Run all automated checks** - Don't skip verification commands (adapt to project's tech stack)
3. **Document everything** - Both successes and issues
4. **Think critically** - Question if the implementation truly solves the problem
5. **Consider maintenance** - Will this be maintainable long-term?
6. **Use generic agents** - Leverage `codebase-analyzer`, `codebase-locator`, and `explore` for discovering implementation details
7. **Save validation reports** - Store comprehensive reports in `thoughts/validation/` for future reference

## Validation Checklist

Always verify:
- [ ] All phases marked complete are actually done
- [ ] Automated tests pass
- [ ] Code follows existing patterns
- [ ] No regressions introduced
- [ ] Error handling is robust
- [ ] Documentation updated if needed
- [ ] Manual test steps are clear

## Relationship to Other Commands

Recommended workflow:
1. `/create_plan` - Create implementation plan (saved to `thoughts/plans/`)
2. `/implement_plan` - Execute the implementation
3. `/commit` - Create atomic commits for changes
4. `/validate_plan` - Verify implementation correctness (save report to `thoughts/validation/`)
5. `/describe_pr` - Generate PR description

The validation works best after commits are made, as it can analyze the git history to understand what was implemented.

## Key Principles for Effective Validation

1. **Understand Before Validating**
   - Read the entire plan before checking implementation
   - Understand the problem being solved, not just the checklist
   - Consider the plan's success criteria as guidance, not gospel

2. **Be Objective and Critical**
   - Validate actual functionality, not just code presence
   - Question assumptions in the plan if implementation reveals issues
   - Don't hesitate to identify improvements or necessary deviations

3. **Verify Comprehensively**
   - Run all automated checks specific to the technology stack
   - Check for edge cases and error handling
   - Verify integration with existing systems
   - Test backwards compatibility if applicable

4. **Communicate Clearly**
   - Provide specific file and line references for issues
   - Distinguish between blockers, warnings, and suggestions
   - Offer actionable recommendations, not just observations

5. **Think Long-term**
   - Consider maintainability and code quality
   - Check if documentation needs updates
   - Evaluate performance implications
   - Assess security considerations

## Best Practices

### When Reading Plans
- Look for both explicit requirements and implied expectations
- Note any assumptions that might be invalid
- Identify potential gaps in the plan itself

### When Checking Code
- Compare intent vs implementation, not just feature checklist
- Look for code smells even if tests pass
- Check consistency with existing codebase patterns
- Verify error messages are helpful and actionable

### When Running Tests
- Don't just check pass/fail - review what's being tested
- Look for missing test cases or edge conditions
- Verify test quality, not just coverage numbers
- Check if tests actually validate the requirements

### When Writing Reports
- Start with high-level summary (pass/fail/partial)
- Group findings by severity (blockers, warnings, suggestions)
- Provide context for why something matters
- Include specific next steps for addressing issues

Remember: Good validation catches issues before they reach production. Be constructive but thorough in identifying gaps or improvements. The goal is quality software, not just checked boxes.
