# agentic-coding-skills

A repo of reusable “skills” (shell scripts + templates + Markdown guides) that you can run from any LLM agent or directly from your terminal.

## Install

1) Clone the repo:

```sh
git clone <repo-url> ~/.agentic/agentic-coding-skills
```

2) Set `AGENT_KIT_HOME` to the repo root (used by docs and scripts for stable absolute paths):

```sh
export AGENT_KIT_HOME="$HOME/.agentic/agentic-coding-skills"
```

3) (Optional) Load repo-local command wrappers into `PATH`:

```sh
source "$AGENT_KIT_HOME/scripts/kit-tools.sh"
```

## Usage

Environment variables used by this repo:

- `AGENT_KIT_HOME` (recommended): absolute path to this repo root.
- `PROJECT_PATH` (optional): used by helper scripts (e.g. desktop notifications) to derive a friendly project title; if unset, helpers fall back to git root or `$PWD`.

Examples:

```sh
# Run a skill script
"$AGENT_KIT_HOME/skills/rest-api-testing/scripts/rest.sh" --help

# Bootstrap a per-repo setup/ directory from a template
mkdir -p setup
cp -R "$AGENT_KIT_HOME/skills/graphql-api-testing/template/setup/graphql" setup/

# Optional: nicer notification titles
export PROJECT_PATH="$PWD"
```

## Project Structure

```text
.
├── .github/   # CI workflows
├── README.md
├── docs/      # output templates
├── prompts/   # prompt templates
├── scripts/   # helpers + command wrappers
└── skills/    # skills (docs + scripts + templates)
```

## 🧰 Prompts

| Prompt | Description | Usage |
| --- | --- | --- |
| actionable-advice | Answer a question with clarifying questions, multiple options, and a single recommendation | `/prompts:actionable-advice <question>` |
| actionable-knowledge | Answer a learning/knowledge question with multiple explanation paths and a single recommended path | `/prompts:actionable-knowledge <question>` |

## 🛠️ Skills

| Skill | Description |
| --- | --- |
| chrome-devtools-site-search | Browse a site via the chrome-devtools MCP server, summarize results, and open matching pages |
| commit-message | Generate Semantic Commit messages from staged changes |
| create-feature-pr | Create feature branches and open a PR with a standard template |
| close-feature-pr | Merge and close PRs after a quick PR hygiene review; delete the feature branch |
| create-progress-pr | Create a progress planning file under docs/progress/ and open a PR (no implementation yet) |
| close-progress-pr | Finalize/archive a progress file for a PR, then merge and patch Progress links to base branch |
| find-and-fix-bugs | Find, triage, and fix bugs; open a PR with a standard template |
| open-changed-files-review | Open files edited by the agent in VSCode after making changes (silent no-op when unavailable) |
| desktop-notify | Send desktop notifications via terminal-notifier (macOS) or notify-send (Linux) |
| api-test-runner | Run CI-friendly API test suites (REST + GraphQL) from a single manifest; emits JSON (+ optional JUnit) results |
| graphql-api-testing | Test GraphQL APIs with repeatable, file-based operations/variables and generate API test reports |
| rest-api-testing | Test REST APIs with repeatable, file-based requests and generate API test reports |
| release-workflow | Execute project release workflows by following RELEASE_GUIDE.md |

## License

MIT © graysurf. See `LICENSE`.
