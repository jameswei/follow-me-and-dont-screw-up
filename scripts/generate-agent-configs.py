#!/usr/bin/env python3
"""
Generate agent-specific configuration files from unified instruction sources.

This script reads from:
- codex/ for the Codex-specific split bundle
- instructions/core/ for the shared, agent-neutral baseline

It then generates:
- codex/ instructions.md (single-file compatibility bundle)
- claude/CLAUDE.md (Claude Code)
- cursor/.cursorrules (Cursor IDE)
- gemini/GEMINI.md (Gemini CLI)

And their Chinese translations in en/ directory.
"""

from pathlib import Path
# Configuration
BASE_DIR = Path(__file__).parent.parent
OUTPUT_DIR = BASE_DIR
CODEX_DIR = OUTPUT_DIR / "codex"
CORE_DIR = OUTPUT_DIR / "instructions" / "core"
CORE_FILES = [
    "01-workflow-overview.md",
    "02-phase1-requirement.md",
    "03-phase2-design.md",
    "04-phase3-implementation.md",
    "05-phase4-demo-docs.md",
    "06-communication.md",
]

# File reading helpers
def read_file(filepath: Path) -> str:
    """Read a file, returning a placeholder if it is missing."""
    if not filepath.exists():
        return f"# {filepath.name} not found\n"
    return filepath.read_text(encoding='utf-8')

def read_codex_file(filename: str) -> str:
    """Read a Codex instruction file."""
    return read_file(CODEX_DIR / filename)

def read_core_file(filename: str) -> str:
    """Read a shared core instruction file."""
    filepath = CORE_DIR / filename
    if not filepath.exists():
        return f"# {filename} not found\n"
    return filepath.read_text(encoding='utf-8')

def read_core_bundle() -> str:
    """Read all shared core files in order."""
    parts = [read_core_file(filename).strip() for filename in CORE_FILES]
    return "\n\n".join(part for part in parts if part)

def read_split_codex_bundle() -> str:
    """Read the Codex split files and combine them into one bundle."""
    parts = [
        read_codex_file("global.md").strip(),
        read_codex_file("project.md").strip(),
    ]
    return "\n\n".join(part for part in parts if part)

# Content transformers
def to_codex_format(content: str) -> str:
    """Convert to Codex format (markdown with clear headers)."""
    header = """# Codex Instructions

This is the compatibility bundle for `~/.codex/instructions.md`.
The split source files live in `codex/global.md` and `codex/project.md`.

"""
    return header + content.strip() + "\n"

def to_claude_format(content: str) -> str:
    """Convert to Claude Code format (CLAUDE.md - similar to Codex)."""
    header = """# CLAUDE.md
# Location: Project root CLAUDE.md
# Purpose: Claude Code system instructions

"""
    return header + content.strip() + "\n"

def to_cursor_format(content: str) -> str:
    """Convert to Cursor format (.cursorrules with specific syntax)."""
    header = """# Cursor Rules
# Location: ~/.cursorrules (global) or project root .cursorrules
# Purpose: Cursor IDE AI assistant behavior rules

"""
    return header + content.strip() + "\n"

def to_gemini_format(content: str) -> str:
    """Convert to Gemini format (GEMINI.md)."""
    header = """# GEMINI.md
# Location: Project root GEMINI.md
# Purpose: Gemini CLI system instructions

"""
    return header + content.strip() + "\n"

# Main generation functions
def generate_codex() -> str:
    """Generate Codex instructions."""
    bundle = read_split_codex_bundle()
    if bundle.strip():
        return to_codex_format(bundle)
    return to_codex_format(read_core_bundle())

def generate_claude() -> str:
    """Generate Claude Code CLAUDE.md."""
    return to_claude_format(read_core_bundle())

def generate_cursor() -> str:
    """Generate Cursor .cursorrules."""
    return to_cursor_format(read_core_bundle())

def generate_gemini() -> str:
    """Generate Gemini CLI GEMINI.md."""
    return to_gemini_format(read_core_bundle())

# Chinese translation (placeholder - can be enhanced with LLM API)
def translate_to_chinese(content: str) -> str:
    """
    Translate content to Chinese.

    For now, this is a placeholder that returns the original content.
    In production, this could call an LLM API for translation.
    """
    # TODO: Implement actual translation using LLM API
    # For now, return content with a header indicating it's not translated
    header = """# 注意：中文版尚未翻译
# Note: Chinese version not yet translated

"""
    return header + content

# File writers
def write_file(path: Path, content: str) -> None:
    """Write content to file, creating directories if needed."""
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding='utf-8')
    print(f"Generated: {path}")

def main():
    """Main entry point."""
    print("=" * 60)
    print("Generating Agent Configuration Files")
    print("=" * 60)

    # Generate English versions
    print("\n--- English Versions ---")

    # Codex
    codex_content = generate_codex()
    write_file(OUTPUT_DIR / "codex" / "instructions.md", codex_content)

    # Claude Code
    claude_content = generate_claude()
    write_file(OUTPUT_DIR / "claude" / "CLAUDE.md", claude_content)

    # Cursor
    cursor_content = generate_cursor()
    write_file(OUTPUT_DIR / "cursor" / ".cursorrules", cursor_content)

    # Gemini
    gemini_content = generate_gemini()
    write_file(OUTPUT_DIR / "gemini" / "GEMINI.md", gemini_content)

    # Generate Chinese versions (in en/ directory for now, can be renamed)
    print("\n--- Chinese Versions (Placeholder) ---")

    # Codex CN
    codex_cn = translate_to_chinese(codex_content)
    write_file(OUTPUT_DIR / "en" / "codex" / "instructions.md", codex_cn)

    # Claude CN
    claude_cn = translate_to_chinese(claude_content)
    write_file(OUTPUT_DIR / "en" / "claude" / "CLAUDE.md", claude_cn)

    # Cursor CN
    cursor_cn = translate_to_chinese(cursor_content)
    write_file(OUTPUT_DIR / "en" / "cursor" / ".cursorrules", cursor_cn)

    # Gemini CN
    gemini_cn = translate_to_chinese(gemini_content)
    write_file(OUTPUT_DIR / "en" / "gemini" / "GEMINI.md", gemini_cn)

    print("\n" + "=" * 60)
    print("Generation Complete!")
    print("=" * 60)
    print("\nGenerated files:")
    print("  - codex/instructions.md")
    print("  - claude/CLAUDE.md")
    print("  - cursor/.cursorrules")
    print("  - gemini/GEMINI.md")
    print("  - en/codex/instructions.md (CN)")
    print("  - en/claude/CLAUDE.md (CN)")
    print("  - en/cursor/.cursorrules (CN)")
    print("  - en/gemini/GEMINI.md (CN)")
    print("\nNote: Chinese translations are placeholders.")
    print("      Run with LLM API integration for actual translation.")


if __name__ == "__main__":
    main()
