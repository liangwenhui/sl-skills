# Team Commit Convention

## Principles
- Keep each commit focused and minimize the number of changed files.
- Avoid repeated commit messages. Use `git commit --amend` only when the user explicitly requests it and the last commit is still safe to rewrite.
- Commit after one small function or one coherent change is complete instead of waiting for a large batch.

## Required Format
`<type>:<subject> <AI-info>`

## Allowed Types
- `feat`: new feature
- `fix`: bug fix
- `docs`: documentation
- `style`: formatting only, no runtime behavior change
- `refactor`: code restructuring without new feature or bug fix
- `perf`: performance improvement
- `test`: add or update tests
- `build`: build system or dependency change
- `ci`: CI config or script change
- `chore`: non-`src` and non-`test` change
- `revert`: revert a commit
- `release`: release version

## AI Flag
- `AI-NONE`: no AI assistance was used
- `AI-USE`: AI assistant generated or materially edited the result

## Example
- `feat:[sp-2882] use string for time field AI-USE`

## Suggested Validation Pattern
- `^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert|release):.+ AI-(NONE|USE)$`
