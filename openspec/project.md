# Project Context

## Purpose

**Tilex** is an open-source "Today I Learned" (TIL) sharing platform built by Hashrocket. It catalogs and shares knowledge snippets learned day-to-day by developers.

Key characteristics:
- Posts limited to **200 words maximum** and **50 character titles**
- Organized by channels (topics/categories like Elixir, Ruby, JavaScript, etc.)
- Originally Ruby on Rails (hr-til), reimplemented in Elixir/Phoenix
- Production: https://til.hashrocket.com

## Tech Stack

### Backend
- **Language**: Elixir 1.19.0 / Erlang OTP 28.1
- **Web Framework**: Phoenix ~> 1.6.14 with LiveView ~> 0.18
- **Database**: PostgreSQL with Ecto ~> 3.6 ORM
- **Authentication**: Ueberauth + Google OAuth 2.0, Guardian JWT tokens
- **Caching**: Cachex ~> 3.1
- **Email**: Swoosh ~> 1.3
- **Monitoring**: AppSignal Phoenix ~> 2.0
- **HTTP Client**: Req ~> 0.5.8

### Frontend
- **Runtime**: Node.js 19.0.0
- **Build Tool**: esbuild ~> 0.4
- **Libraries**: jQuery 3.6.1, CodeMirror 5.65.9 (code editor), Autosize 5.0.1
- **Rendering**: Phoenix HTML/LiveView (server-rendered)
- **Styling**: Custom CSS (no framework), Prism syntax highlighting

### APIs & Integrations
- **MCP (Model Context Protocol)**: Hermes.MCP ~> 0.14.1 for AI tool integration
- **Markdown**: Earmark ~> 1.4.4
- **HTML Processing**: Floki ~> 0.34, html_sanitize_ex ~> 1.2

### Development Tools
- **Linting**: Credo ~> 1.6
- **Testing**: ExUnit, Wallaby ~> 0.30.1 (browser tests)
- **AI Dev Tools**: Tidewave ~> 0.5

## Project Conventions

### Code Style

**Formatting:**
- Elixir built-in formatter (`mix format`) configured in `.formatter.exs`
- Auto-imports Ecto and Phoenix deps formatting
- Required to pass CI checks

**Linting:**
- Credo linter in non-strict mode
- Checks `lib/`, `test/`, and `web/` directories
- Required to pass CI checks

**Naming Conventions:**
- Modules: PascalCase (e.g., `Tilex.Blog.Post`)
- Functions/variables: snake_case
- Private functions: `defp`
- Schema fields: atom keys in changesets

**Organization:**
- Business logic: `lib/tilex/` organized by domain (blog/, auth/, notifications/, etc.)
- Web layer: `lib/tilex_web/` (controllers, views, templates)
- Mix tasks: `lib/mix/tasks/`
- Strict separation of concerns (MVC pattern)

### Architecture Patterns

**Application Structure:**
- OTP application with supervision tree
- GenServer-based services: Notifications, RateLimiter, MCP Server
- Phoenix Endpoint with custom Plug middleware pipeline

**Database Patterns:**
- Schema-first ORM with Ecto
- Changesets for validation and transformations
- Composable queries using `Ecto.Query`
- Foreign keys and unique constraints at DB + code levels
- UTC datetime format (`:utc_datetime`)

**Web Patterns:**
- REST-like JSON API endpoints (`/api/recent_posts.json`, `/api/developer_posts.json`)
- Separate view modules for rendering (HTML, JSON, RSS, sitemap)
- WebSocket support for real-time features (text conversion preview)
- Rate limiting middleware to prevent abuse

**Core Services:**
- **Cachex**: In-memory caching for frequently accessed data
- **PubSub**: Real-time communication via Phoenix.PubSub
- **Telemetry**: Metrics collection and monitoring
- **Notifications**: Event-driven system with pluggable notifiers (Slack, Twitter, Webhooks)

### Testing Strategy

**Unit Tests:**
- Test models/schemas directly (e.g., `test/tilex/blog/post_test.exs`)
- Validates business logic, changesets, and constraints

**Integration Tests:**
- Wallaby browser tests in `test/features/`
- Cover user workflows: homepage visits, post viewing/creation, profile editing, RSS feeds
- Example: `test/features/visitor_visits_homepage_test.exs`

**CI Pipeline:**
- GitHub Actions with PostgreSQL service
- Checks: `mix format --check-formatted`, `mix credo`, `mix test`
- Must pass before merging

**Test Support:**
- Test doubles and helpers in `lib/test/`
- Factory-style fixtures via Ecto

### Git Workflow

**Branching:**
- Main branch: `master`
- Feature branches: descriptive names (e.g., `mcp-server`, `my-new-feature`)
- PR-based workflow for all contributions

**Commit Conventions:**
- Prefix style: `feat:`, `fix:`, `refactor:`, `chore:`, `ci:`, `docs:`
- Clear, descriptive messages
- Examples:
  - `feat: use Req basic auth in webhook notifier`
  - `refactor: use developer username on webhook`
  - `chore: bump ci elixir and otp versions`

**PR Requirements:**
1. Fork and create feature branch
2. Make changes with accompanying tests
3. Run `mix test` (all tests must pass)
4. Run `mix format` (code must be formatted)
5. Run `mix credo` (no linting errors)
6. Stage changes with `git add --patch`
7. Clear commit message
8. Push and create PR

**Database Migrations:**
- Must be reversible (checked with `mix ecto.twiki`)
- Timestamped filenames in `priv/repo/migrations/`

**Deployment:**
- Custom mix task: `mix deploy <environment>`
- Post-deploy: `mix ecto.migrate && mix run priv/repo/seeds.exs`
- Heroku-based with Elixir + Phoenix static buildpacks

## Domain Context

**Core Entities:**

1. **Post** (TIL post)
   - Fields: `title` (max 50 chars), `body` (max 200 words), `slug`, `likes`, `max_likes`, `tweeted_at`
   - Relationships: `belongs_to :channel`, `belongs_to :developer`
   - Slug auto-generated from random bytes for uniqueness
   - Markdown body with HTML sanitization via `Tilex.Blog.PostScrubber`

2. **Channel** (Topic category)
   - Fields: `name`, `twitter_hashtag`
   - Relationships: `has_many :posts`
   - URL-friendly names (e.g., elixir, ruby, javascript)

3. **Developer** (User/Author)
   - Fields: `email`, `username`, `twitter_handle`, `admin`, `editor`
   - Relationships: `has_many :posts`
   - OAuth-integrated: creates on first Google login, retrieves on subsequent
   - Admin/editor flags for permissions

**Key Domain Logic:**

- **Post Liking**: Users can like posts; `max_likes` tracks peak popularity
- **Rate Limiting**: Custom rate limiter prevents abuse (configurable via env vars)
- **Markdown Rendering**: Posts use Earmark with HTML sanitization
- **Slug Generation**: Format `{slug}-{slugified-title}` for shareable URLs
- **Page Views**: Tracked and reported for statistics
- **Search**: Basic search with Floki HTML parsing
- **Notifications**: Post creation triggers Slack, Twitter, and Webhook notifications
- **MCP Tools**: AI assistants can list channels and create posts via MCP server

## Important Constraints

**Technical:**
- Posts: 200 word limit (validated at model level)
- Titles: 50 character limit
- Database foreign key constraints on `channel_id` and `developer_id`
- Slug uniqueness via random generation
- Rate limiting enforced via custom middleware

**Business:**
- Google OAuth required for authentication
- Optional domain restrictions via `HOSTED_DOMAIN` env var
- Guest author allowlist for external contributors
- Admin/editor permissions for moderation

**Deployment:**
- Heroku platform constraints
- Environment variables required for all secrets
- PostgreSQL addon required
- AppSignal addon for monitoring

## External Dependencies

1. **Google OAuth 2.0** (ueberauth_google)
   - User authentication with Google accounts
   - Domain restrictions via `HOSTED_DOMAIN`
   - Guest author allowlist: `GUEST_AUTHOR_ALLOWLIST`

2. **Twitter API** (custom via Req)
   - Post TILs to Twitter with hashtags
   - Config: `TWITTER_CONSUMER_KEY`, `TWITTER_CONSUMER_SECRET`, `TWITTER_ACCESS_TOKEN`, `TWITTER_ACCESS_TOKEN_SECRET`

3. **Slack Webhooks**
   - Notify Slack channel on new posts
   - Config: `SLACK_POST_ENDPOINT`

4. **Imgur API**
   - Image upload for post content
   - Config: `IMGUR_CLIENT_ID`

5. **PostgreSQL**
   - Heroku Postgres addon
   - Connection pooling via Ecto

6. **Heroku Platform**
   - Hosting and deployment
   - Buildpacks: Elixir + Phoenix static
   - Procfile for process management

7. **Model Context Protocol (MCP)** (Hermes.MCP)
   - AI assistant integration (Claude, etc.)
   - Tools: `list_channels`, `new_post`
   - Auth: `X-API-Key` header

8. **Generic Webhooks**
   - POST requests on post creation
   - Config: `WEBHOOK_URL`, `WEBHOOK_BASIC_AUTH`

9. **AppSignal**
   - APM and error tracking
   - Ecto query monitoring
