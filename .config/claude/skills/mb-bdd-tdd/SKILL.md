---
name: mb-bdd-tdd
description: Use when writing or editing Playwright E2E test files (typically `*.spec.ts` under `tests/`, `e2e/`, or `playwright/`), or when porting Cypress tests to Playwright. Also use when editing Cypress test files in projects that follow Mo's BDD dialect (speedoku). Symptoms include drafting a `test(...)` block without Gherkin comments, using CSS/class selectors for assertions instead of `data-*` attributes, missing the file-level user story header, or skipping the success log at scenario end.
---

# mb-bdd-tdd

## Overview

Mo's testing style is **explicit, narrative-driven Gherkin codified at every level of the test file**: file header, describe block, beforeEach, and `test` all carry semantic naming. Assertions hit `data-*` attributes, never CSS or class names. Every scenario ends with a `✅` annotation on the Playwright `test.info()` (so it surfaces in HTML reports), with optional `console.log` breadcrumbs at intermediate steps for failure-debug visibility. Domain actions are wrapped in helper functions; raw selectors do not appear in test bodies.

This is *not* generic BDD — Mo has rigid conventions. The skill enforces them.

## When to use

- Writing a new Playwright test file (`*.spec.ts`, `e2e/`, `tests/`, `playwright/`)
- Editing an existing test in a project that follows this dialect
- Porting Cypress tests to Playwright (speedoku → future projects)
- Adding a new scenario to an existing test file

## When NOT to use

- Unit tests (Vitest, Jest) — those are tiny and don't need the full Gherkin scaffold
- Tests in a project with its own explicit different style codified in the project AGENTS.md (project overlay wins)

## File structure (mandatory)

Every test file has four levels of Gherkin naming + a JSDoc user-story header. Success logs go to `test.info().annotations` (report-visible); transient debug breadcrumbs use `console.log` (visible in stdout on failure):

```typescript
/**
 * Feature: Timer System
 *
 * As a player
 * I want to see a timer tracking my solve time
 * So that I can measure my speed
 */

import { test, expect } from '@playwright/test';
import { selectNumber, clickCell, loadPuzzle } from '../helpers/sudoku';

const PUZZLE   = '...' as const;  // 81 chars
const SOLUTION = '...' as const;

// pass(description) — appends a ✅ annotation to the current test's report row
const pass = (description: string) =>
  test.info().annotations.push({ type: '✅', description });

test.describe('Feature: Timer System', () => {
  test.beforeEach('Background: Navigate to Play screen', async ({ page }) => {
    // Given I am on the Play screen with a puzzle loaded
    await loadPuzzle(page, PUZZLE, SOLUTION);
  });

  test('Scenario: Timer starts at 00:00.00', async ({ page }) => {
    // Then the timer should show 00:00.00
    await expect(page.getByTestId('timer')).toHaveText('00:00.00');

    pass('Timer starts at zero');
  });

  test('Scenario: Timer advances when a cell is filled', async ({ page }) => {
    // When I fill an empty cell with the correct number
    await selectNumber(page, 3);
    await clickCell(page, 0, 2);

    // debug breadcrumb: capture the visible timer text before assertion so
    // failure logs show what we saw, not just "expected not to equal"
    const observed = await page.getByTestId('timer').textContent();
    console.log(`[timer] observed=${observed} after first fill`);

    // Then the timer should be non-zero within a second
    await expect(page.getByTestId('timer')).not.toHaveText('00:00.00');

    pass('Timer advances on first action');
  });
});
```

**Why two channels?**
- `test.info().annotations` surfaces in the HTML report and CI summary — the success log is *part of the test outcome*, not console noise.
- `console.log` is the right tool for transient debugging breadcrumbs (state captures, branching values). They stay quiet on green runs but anchor failure investigation. Don't dress these up with ✅ — that emoji is reserved for the scenario completion annotation.

## Required conventions ("Mo-isms")

| Convention | Rule |
| ---------- | ---- |
| File header | JSDoc with `Feature: X` line + 3-line user story (`As a / I want / So that`) |
| Test data | 81-char `PUZZLE` and `SOLUTION` constants at top of file with `as const`; never inline in tests |
| `describe` | Named `Feature: <name>` matching the file header |
| `beforeEach` | Named `Background: <action>` (Gherkin-aligned). Never `"setup"` or `"before each"` |
| `test`      | Named `Scenario: <user-facing outcome>` |
| Step comments | Every action commented with `// Given`, `// When`, `// Then`, `// And` prefixes |
| Selectors  | `page.getByTestId('x')` first; raw `[data-testid=...]` only when getByTestId can't express it |
| Assertions | `data-*` attributes only: `toHaveAttribute('data-selected', 'true')`, `toHaveText`, `toBeVisible`. **Never** CSS, class names, or computed styles |
| Helpers    | All repeated actions extracted to `helpers/<domain>.ts` (`selectNumber`, `clickCell`, `loadPuzzle`) — raw selectors do not appear in test bodies |
| Success log | Every `test` ends with `pass('<human-readable scenario name>')` (a wrapper around `test.info().annotations.push({ type: '✅', description })`). Emoji is **always the green checkmark** (✅) and lives in the annotation type field |
| Debug breadcrumbs | Optional `console.log(...)` between steps to capture intermediate state. Use when an assertion isn't enough to explain a future failure ("what did we *see* before failing?"). Never use ✅ in console.log — that's annotation territory |

## Data attribute conventions

State lives in `data-*` attributes on the DOM, never in CSS classes. Common ones:

| Attribute | Values | Use |
| --------- | ------ | --- |
| `data-testid` | unique string | Primary element identifier |
| `data-selected` | `"true"` / `"false"` | Selection state (highlighted button, focused cell) |
| `data-disabled` | `"true"` / `"false"` | Button enabled/disabled state |
| `data-active`   | `"true"` / `"false"` | Toggle state (on/off modes) |
| `data-given`    | `"true"` / `"false"` | "Cannot be modified" markers (pre-filled cells) |
| `data-mode`     | domain-specific | Current game/UI mode |

Add new `data-*` attributes when state needs assertion — don't infer state from styling.

## Helper module pattern

Domain actions live in `helpers/<domain>.ts`, not in test bodies. Cypress had `Cypress.Commands.add()`; Playwright doesn't — use plain async functions taking `page` as first arg:

```typescript
// helpers/sudoku.ts
import { Page } from '@playwright/test';

export async function loadPuzzle(page: Page, puzzle: string, solution: string) {
  await page.goto(`/?puzzle=${puzzle}&solution=${solution}`);
}

export async function selectNumber(page: Page, num: number) {
  await page.getByTestId(`number-btn-${num}`).click();
}

export async function clickCell(page: Page, row: number, col: number) {
  await page.getByTestId(`cell-${row}-${col}`).click();
}
```

Test bodies call helpers, never raw selectors. If a test needs a raw selector, the action probably belongs in helpers.

## Cypress → Playwright cheat sheet

For porting speedoku-style Cypress tests:

| Cypress | Playwright |
| ------- | ---------- |
| `cy.visit(url)` | `await page.goto(url)` |
| `cy.get('[data-testid="x"]')` | `page.getByTestId('x')` |
| `cy.get(...).click()` | `await locator.click()` |
| `cy.get(...).should('be.visible')` | `await expect(locator).toBeVisible()` |
| `cy.get(...).should('have.text', 't')` | `await expect(locator).toHaveText('t')` |
| `cy.get(...).should('have.attr', 'a', 'v')` | `await expect(locator).toHaveAttribute('a', 'v')` |
| `cy.get(...).should('contain.text', 't')` | `await expect(locator).toContainText('t')` |
| `cy.get(...).as('x')` then `cy.get('@x')` | `const x = page.getByTestId(...);` (plain variable) |
| `cy.fixture('puzzles')` | `import puzzles from '../fixtures/puzzles.json'` |
| `cy.log('✅ x')` | `pass('x')` (success annotation, report-visible) |
| `cy.log('debug:', value)` | `console.log('debug:', value)` (stdout breadcrumb, no emoji) |
| `Cypress.Commands.add('foo', ...)` | plain async helper function in `helpers/<domain>.ts` |
| `cy.get(...).then(($el) => {...})` | `const text = await locator.textContent();` then use it |

## Common mistakes

- Drafting `test('does the thing', ...)` without `Scenario:` prefix
- Using `await page.locator('[data-testid="x"]')` instead of `await page.getByTestId('x')` when the former works
- Asserting on class names or computed styles to check state — **add a `data-*` attribute instead**
- Skipping the `pass('...')` annotation at scenario end — it's the report-visible test summary, not optional
- Using `console.log('✅ ...')` instead of `pass('...')` — the ✅ belongs in the annotation, not stdout
- Inlining puzzle/test data inside a test instead of defining as top-level `as const`
- Letting raw selectors creep into test bodies instead of extracting to helpers
- Putting "step 1 / step 2" comments instead of `// Given / // When / // Then`

## Quick reference

| Layer | Naming pattern | Example |
| ----- | -------------- | ------- |
| File header | `Feature: X` + user story | `Feature: Timer System` |
| `describe` | `Feature: <name>` | `Feature: Sudoku Grid` |
| `beforeEach` | `Background: <action>` | `Background: Navigate to Play screen` |
| `test` | `Scenario: <outcome>` | `Scenario: Grid displays 81 cells` |
| step comment | `// Given / When / Then / And` | `// When I select number 5` |
| success log | `pass('<summary>')` → annotation | `pass('Grid displays 81 cells')` |
| debug breadcrumb | `console.log(...)` | `console.log('[cell] given=', isGiven)` |
