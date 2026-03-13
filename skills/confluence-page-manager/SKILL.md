---
name: confluence-page-manager
description: Read and write Confluence pages via REST API. Use when user asks to fetch page content by page ID, summarize existing Confluence pages, create new pages, or update page content in Confluence.
---

# Confluence Page Manager

## Inputs
- `action`: `read` | `create` | `update`
- `page_id` (required for `read` and `update`)
- `title` (required for `create`; optional for `update`)
- `space_key` (required for `create`)
- `body_storage`: Confluence storage format body (required for `create` and `update`)

## Required Environment
- `CONFLUENCE_BASE_URL` (example: `https://your-domain.atlassian.net`)
- `CONFLUENCE_EMAIL`
- `CONFLUENCE_API_TOKEN`

## Mandatory Config Bootstrap
1. Check required env vars before any Confluence API call.
2. If any var is missing, ask user to provide missing values one by one.
3. After user provides values, configure env in current shell session, then continue automatically.
4. Do not ask user to run commands manually unless user explicitly wants manual mode.
5. Never print or repeat full token in response.

Recommended setup command after collecting values:
```bash
export CONFLUENCE_BASE_URL='https://your-domain.atlassian.net'
export CONFLUENCE_EMAIL='name@company.com'
export CONFLUENCE_API_TOKEN='***'
```

## Workflow
1. Confirm `action` and required fields.
2. Ensure environment is ready via Mandatory Config Bootstrap.
3. Execute script:
   - `read`: `skills/scripts/confluence_get_page.sh <page_id>`
   - `create`: `skills/scripts/confluence_write_page.sh create <space_key> <title> <body_file>`
   - `update`: `skills/scripts/confluence_write_page.sh update <page_id> <title_or_dash> <body_file>`
4. Return a concise summary first, then key fields (`id`, `title`, `version`, `url`).

## Output Contract
1. Result: what was read/created/updated.
2. Key Fields: page id, title, version, link.
3. Next Steps: validation or follow-up edits.

## Failure Handling
- Missing env vars: trigger config bootstrap flow and continue.
- 401/403: verify token and Confluence permissions.
- 404: verify page id and site visibility.
- 409 on update: fetch latest version and retry with incremented version.

## Notes
- Script uses Confluence REST API v1 (`/wiki/rest/api/content`).
- `body_storage` must be valid Confluence storage format (XHTML-like markup).

## Templates
- Technical solution template:
  `skills/confluence-page-manager/templates/technical-solution.storage`
- Inventory template:
  `skills/confluence-page-manager/templates/inventory.storage`

Use with create/update:
```bash
skills/scripts/confluence_write_page.sh create <space_key> <title> skills/confluence-page-manager/templates/technical-solution.storage
```
