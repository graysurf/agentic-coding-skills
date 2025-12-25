# agentic-coding-skills

agentic-coding-skills tracks Agentic Coding Tool setup to keep workflows consistent across machines. It contains prompt presets, custom skills, and local tooling wrappers.

## 🗂️ Project Structure

```text
.
├── AGENTS.md
├── README.md
├── prompts/      # prompt templates
├── scripts/      # helper scripts
├── skills/       # custom skills
└── templates/    # shared templates
```

## 🧰 Prompts

| Prompt | Description | Usage |
| --- | --- | --- |
| [openspec-apply](prompts/openspec-apply.md) | Implement an approved OpenSpec change | `/prompts:openspec-apply <id>` |
| [openspec-archive](prompts/openspec-archive.md) | Archive an OpenSpec change and update specs | `/prompts:openspec-archive <id>` |
| [openspec-proposal](prompts/openspec-proposal.md) | Scaffold a new OpenSpec change | `/prompts:openspec-proposal <request>` |

## 🛠️ Skills

| Skill | Description |
| --- | --- |
| [chrome-devtools-site-search](skills/chrome-devtools-site-search) | Validate website parsing and browser automation feasibility via site-scoped browsing/search (chrome-devtools MCP) |
| [commit-message](skills/commit-message) | Generate Semantic Commit messages from staged changes |
| [create-feature-pr](skills/create-feature-pr) | Create feature branches and open PRs with a standard template |
| [find-and-fix-bugs](skills/find-and-fix-bugs) | Find, triage, and fix bugs; open a PR with gh |
| [release-workflow](skills/release-workflow) | Execute project release workflows by following RELEASE_GUIDE.md |

## 📜 Notes

- This project expects the `$CLI_TOOLS` environment variable to be set to a local directory containing shared CLI tooling (shell scripts and helpers) used by prompts and skills in this repo.
- [`git-scope`](https://github.com/graysurf/zsh-kit/tree/main/docs/git-scope.md) and [`git-commit-message`](https://github.com/graysurf/zsh-kit/tree/main/scripts/git/git-tools.zsh#L739) commands are used in commit and pull request workflows. For more details, see [zsh-kit](https://github.com/graysurf/zsh-kit).
