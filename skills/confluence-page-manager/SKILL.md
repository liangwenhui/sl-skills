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

## Required Environment (Single Config)
- `ATLASSIAN_BASE_URL`
- `ATLASSIAN_EMAIL`
- `ATLASSIAN_API_TOKEN`

## Mandatory Config Bootstrap (Persistent)
1. First run check script: `skills/scripts/check_atlassian_env.sh`
2. If check fails (non-zero exit), proceed with bootstrap:
   - Ask user to provide missing values one by one.
   - Persist config by running:
     `skills/scripts/setup_atlassian_env.sh <base_url> <email> <api_token>`
3. Continue automatically after persistence.
4. Never print or repeat full token in response.

## Workflow
1. Confirm `action` and required fields.
2. Ensure environment is ready via Mandatory Config Bootstrap.
3. Execute script:
   - `read`: `skills/scripts/confluence_get_page.sh <page_id>`
   - `create`: `skills/scripts/confluence_write_page.sh create <space_key> <title> <body_file>`
   - `update`: `skills/scripts/confluence_write_page.sh update <page_id> <title_or_dash> <body_file>`
4. Return a concise summary first, then key fields (`id`, `title`, `version`, `url`).

## Templates
- `skills/confluence-page-manager/templates/technical-solution.storage`
- `skills/confluence-page-manager/templates/inventory.storage`
