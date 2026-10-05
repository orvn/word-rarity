![Alpine.js](https://img.shields.io/badge/Alpine.js-8BC0D0?style=flat&logo=alpinedotjs&logoColor=black) ![Astro](https://img.shields.io/badge/Astro-FF5D01?style=flat&logo=astro&logoColor=white) ![Bun](https://img.shields.io/badge/Bun-000000?style=flat&logo=bun&logoColor=white) ![Conventional Commits](https://img.shields.io/badge/Conventional_Commits-FE5196?style=flat&logo=conventionalcommits&logoColor=white)

# Word Rarity

An exploration into the rarity of words in the English language

## Stack

- **Astro 7**: static output, client-side routing via `<ClientRouter />`
- **Alpine.js**: lightweight interactivity, no build step
- **Bun**: package manager and script runner
- **SCSS**: including breakpoint mixins and Foundation-type base styles


## Structure

Bun workspaces monorepo, packages:

- `packages/site` (`@word-rarity/site`): frontend site
- `packages/data` (`@word-rarity/data`): data analysis

## Quickstart

Run from the repo root:

```bash
bun install        # requires node 22+
bun run dev        # local development
bun run build      # outputs to packages/site/dist
bun run preview    # preview the dist build locally
bun run check      # type check every package
```

To run a script in one package, use `bun run --filter @word-rarity/site <script>` or `cd` into it.

_(Use `bun run build` rather than `bun build`, which invokes bun's own bundler instead of the script)_

## Commit messages

Commits must use a conventional prefix, `.githooks/` rejects anything else.

Allowed types: `feat`, `fix`, `hotfix`, `refactor`, `style`, `chore`, `cleanup`, `perf`, `test`, `docs`, `content`


## Deployment

Assuming a static site host like Cloudflare Pages, Github Pages, Netlify, etc.

- Build command: `bun run build`
- Set output directory: `packages/site/dist`
- Ensure Node version is set to **22** or higher in environment settings
- Add any environment variables (none by default)
