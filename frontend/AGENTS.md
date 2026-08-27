# Frontend

## What this is

A pure frontend demo of the Kanban board — no backend, no auth, no persistence. All state lives in React memory and resets on page reload. This will be wired to the backend API in Part 7.

## Stack

- Next.js 16, React 19, TypeScript
- Tailwind CSS v4 (CSS-first config via `globals.css`, no `tailwind.config.*`)
- `@dnd-kit/core` + `@dnd-kit/sortable` for drag-and-drop
- Vitest + Testing Library for unit tests
- Playwright for E2E tests

## File structure

```
src/
  app/
    layout.tsx          root layout, loads Google Fonts (Space Grotesk display, Manrope body)
    page.tsx            renders <KanbanBoard />
    globals.css         CSS variables for the color scheme + Tailwind import
  components/
    KanbanBoard.tsx     top-level stateful component; owns all board state and handlers
    KanbanColumn.tsx    renders one column; droppable target; contains card list + NewCardForm
    KanbanCard.tsx      individual draggable card with title, details, and a delete button
    KanbanCardPreview.tsx  static clone rendered by DragOverlay during a drag
    NewCardForm.tsx     inline add-card form (toggled open/closed per column)
  lib/
    kanban.ts           types (Card, Column, BoardData), initialData, moveCard, createId
    kanban.test.ts      unit tests for moveCard
  test/
    setup.ts            Vitest setup (extends jest-dom matchers)
    vitest.d.ts         type augmentation for jest-dom
tests/
  kanban.spec.ts        Playwright E2E tests
```

## Data model

```ts
type Card   = { id: string; title: string; details: string }
type Column = { id: string; title: string; cardIds: string[] }
type BoardData = { columns: Column[]; cards: Record<string, Card> }
```

Columns are an ordered array. Card order within a column is the `cardIds` array order. Cards are stored flat in a lookup map keyed by id.

## Color scheme (CSS variables)

| Variable             | Value     | Usage                        |
|----------------------|-----------|------------------------------|
| `--accent-yellow`    | `#ecad0a` | accent lines, drag highlights |
| `--primary-blue`     | `#209dd7` | links, key sections          |
| `--secondary-purple` | `#753991` | submit buttons               |
| `--navy-dark`        | `#032147` | main headings, body text     |
| `--gray-text`        | `#888888` | supporting text, labels      |
| `--surface`          | `#f7f8fb` | page background              |
| `--stroke`           | `rgba(3,33,71,0.08)` | borders        |

Always use these variables — never hardcode hex values.

## Fonts

- `--font-display` (Space Grotesk): headings, card titles — apply via `font-display` class
- `--font-body` (Manrope): all other text — default body font

## Key behaviors

- **Column rename**: the column title is an `<input>` that fires `onRename` on every keystroke (controlled, immediate)
- **Add card**: each column has a `NewCardForm` that toggles open; requires a non-empty title; details are optional
- **Delete card**: "Remove" button on each card; no confirmation dialog
- **Drag-and-drop**: dropping a card onto a column drops it at the end; dropping onto another card inserts before that card; same-column reordering supported

## Tests

Run unit tests: `npm run test:unit` (Vitest)
Run E2E tests: `npm run test:e2e` (Playwright, requires the dev server or built app running)
Run all: `npm run test:all`

Unit tests use `jsdom` environment (configured in `vitest.config.ts`). `data-testid` attributes are present on columns (`column-{id}`) and cards (`card-{id}`) for test targeting.

## Notes for agents

- This is currently a frontend-only demo. Do not add API calls here until Part 7 instructs it.
- When adding a login page (Part 4), add it as `src/app/login/page.tsx` — do not modify `page.tsx` until auth is wired.
- When switching to static export (Part 3), set `output: 'export'` in `next.config.ts`. This disables API routes and server components — keep everything client-side (`"use client"`).
- The `initialData` in `kanban.ts` is replaced by a real API call in Part 7; do not remove it before then.
