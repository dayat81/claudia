# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Frontend Development
- `bun run dev` - Start Vite development server for frontend only
- `bun run build` - Build frontend (TypeScript compilation + Vite build)
- `bun run preview` - Preview production build
- `bunx tsc --noEmit` - Type checking without emitting files

### Tauri Development
- `bun run tauri dev` - Start development server with hot reload (frontend + backend)
- `bun run tauri build` - Production build with platform-specific bundles
- `bun run tauri build --debug` - Debug build (faster compilation)
- `bun run tauri build --no-bundle` - Build executable without installer

### Rust Backend
- `cd src-tauri && cargo test` - Run Rust test suite
- `cd src-tauri && cargo fmt` - Format Rust code
- `cd src-tauri && cargo clippy` - Rust linting

## Architecture Overview

### Tech Stack
- **Frontend**: React 18 + TypeScript + Vite 6 + Tailwind CSS v4
- **Backend**: Rust with Tauri 2 framework
- **UI Components**: shadcn/ui components with Radix UI primitives
- **Database**: SQLite via rusqlite for local data storage
- **Package Manager**: Bun for JavaScript dependencies

### Project Structure

#### Frontend (`src/`)
- `components/` - React UI components including specialized views for agents, sessions, settings
- `lib/` - Utilities (API client, date utils, output caching, syntax themes)
- `types/` - TypeScript type definitions
- `assets/` - Static assets and styling

#### Backend (`src-tauri/src/`)
- `commands/` - Tauri command handlers for frontend-backend communication
  - `agents.rs` - Agent creation and execution
  - `claude.rs` - Claude Code CLI integration
  - `mcp.rs` - Model Context Protocol server management
  - `sandbox.rs` - Security sandboxing
  - `screenshot.rs` - Screen capture functionality
  - `usage.rs` - Usage analytics and cost tracking
- `sandbox/` - Advanced security sandboxing system
  - Platform-specific implementations (seccomp on Linux, Seatbelt on macOS)
  - Permission profiles and violation tracking
- `checkpoint/` - Session timeline and checkpoint management
- `process/` - Process registry and management

### Key Features Architecture

#### Agent System
- Custom AI agents with specialized system prompts
- Secure execution in sandboxed environments
- Agent templates stored in `cc_agents/` directory
- Execution history and performance tracking

#### Sandboxing
- OS-level security with platform-specific implementations
- Granular permission control (filesystem, network, process isolation)
- Violation logging and audit trails
- Reusable security profiles

#### Session Management
- Integration with Claude Code CLI sessions in `~/.claude/projects/`
- Session history browsing and resumption
- Checkpoint system for session versioning
- Timeline navigation with branching support

#### Usage Analytics
- Real-time cost and token tracking
- Model-specific usage breakdown
- Visual charts with recharts library
- Export functionality for usage data

## Development Guidelines

### Frontend Development
- Uses path alias `@/*` for `./src/*` imports
- Strict TypeScript configuration with full linting enabled
- Component composition with shadcn/ui patterns
- Tailwind CSS v4 for styling with utility-first approach

### Backend Development
- Async/await pattern with Tokio runtime
- Error handling with anyhow crate
- Structured logging with log and env_logger
- Database operations use rusqlite with bundled SQLite

### Testing
- Rust tests in `src-tauri/tests/` with comprehensive sandbox testing
- Unit, integration, and E2E test structure
- Property-based testing with proptest
- Serial test execution for resource-sensitive tests

### Security Considerations
- All agent execution happens in sandboxed environments
- No data collection - everything stays local
- Filesystem access uses whitelist-based permissions
- Network restrictions configurable per agent

## Common Workflows

### Adding New Agent Features
1. Update agent schema in `src-tauri/src/commands/agents.rs`
2. Add UI components in `src/components/`
3. Update database schema if needed
4. Add sandbox permissions if required

### Extending Sandbox Capabilities
1. Modify platform-specific modules in `src-tauri/src/sandbox/`
2. Update permission profiles
3. Add violation detection rules
4. Update UI for permission configuration

### Adding New Claude Code Integrations
1. Extend command handlers in `src-tauri/src/commands/claude.rs`
2. Update session management logic
3. Add UI components for new features
4. Update checkpoint system if needed