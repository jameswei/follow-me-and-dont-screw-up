#!/usr/bin/env python3
"""
Generate agent-specific configuration files from unified instruction sources.

This script reads from instructions/core/ and generates:
- codex/instructions.md (OpenAI Codex)
- claude/CLAUDE.md (Claude Code)
- cursor/.cursorrules (Cursor IDE)

And their Chinese translations in en/ directory.
"""

import os
import re
from pathlib import Path
from typing import List, Dict

# Configuration
BASE_DIR = Path(__file__).parent.parent
INSTRUCTIONS_DIR = BASE_DIR / "instructions"
CORE_DIR = INSTRUCTIONS_DIR / "core"
OUTPUT_DIR = BASE_DIR

# File reading helpers
def read_core_file(filename: str) -> str:
    """Read a core instruction file."""
    filepath = CORE_DIR / filename
    if not filepath.exists():
        return f"# {filename} not found\n"
    return filepath.read_text(encoding='utf-8')

def read_all_core() -> str:
    """Read all core files in order."""
    files = [
        "01-workflow-overview.md",
        "02-phase1-requirement.md",
        "03-phase2-design.md",
        "04-phase3-implementation.md",
        "05-phase4-demo-docs.md",
        "06-communication.md",
    ]
    content = []
    for f in files:
        content.append(read_core_file(f))
    return "\n\n".join(content)

# Content transformers
def to_codex_format(content: str) -> str:
    """Convert to Codex format (markdown with clear headers)."""
    header = """# Codex Instructions
# Location: ~/.codex/instructions.md (global) or project root codex.md
# Purpose: OpenAI Codex CLI/App system-level instructions

# =============================================================================
# CORE WORKFLOW: FOUR-PHASE MANDATORY PROCESS
# =============================================================================

## Iron Rule: Never Write Implementation Code Directly

You MUST follow this four-phase workflow. **Never skip phases or jump ahead.**

"""
    # Clean up the content for Codex
    cleaned = content.replace("# ", "## ")
    cleaned = cleaned.replace("## ", "### ", 1)  # First header stays as section
    
    return header + cleaned

def to_claude_format(content: str) -> str:
    """Convert to Claude Code format (CLAUDE.md - similar to Codex)."""
    header = """# CLAUDE.md
# Location: Project root CLAUDE.md
# Purpose: Claude Code system instructions

# =============================================================================
# CORE WORKFLOW: FOUR-PHASE MANDATORY PROCESS
# =============================================================================

## Iron Rule: Never Write Implementation Code Directly

You MUST follow this four-phase workflow. **Never skip phases or jump ahead.**

"""
    # Claude Code uses similar markdown format as Codex
    return header + content

def to_cursor_format(content: str) -> str:
    """Convert to Cursor format (.cursorrules with specific syntax)."""
    header = """# Cursor Rules
# Location: ~/.cursorrules (global) or project root .cursorrules
# Purpose: Cursor IDE AI assistant behavior rules

# =============================================================================
# CORE WORKFLOW: FOUR-PHASE MANDATORY PROCESS
# =============================================================================

# Iron Rule: Never write implementation code directly
# You MUST follow this four-phase workflow for ALL tasks

"""
    
    # Transform markdown headers to Cursor comment style
    lines = content.split('\n')
    result = []
    in_code_block = False
    
    for line in lines:
        # Track code blocks
        if line.strip().startswith('```'):
            in_code_block = not in_code_block
            result.append(line)
            continue
        
        # Inside code blocks, keep as-is
        if in_code_block:
            result.append(line)
            continue
        
        # Transform headers to Cursor style
        if line.startswith('# '):
            result.append(f"# {'=' * 77}")
            result.append(f"# {line[2:].upper()}")
            result.append(f"# {'=' * 77}")
        elif line.startswith('## '):
            result.append(f"\n# {'-' * 77}")
            result.append(f"# {line[3:]}")
            result.append(f"# {'-' * 77}")
        elif line.startswith('### '):
            result.append(f"\n### {line[4:]}")
        elif line.startswith('- ') or line.startswith('- [') or line.startswith('|'):
            # Keep list items and tables
            result.append(line)
        elif line.strip() and not line.startswith('#'):
            # Regular text - add as comment if not already
            if not line.strip().startswith('```'):
                result.append(line)
        else:
            result.append(line)
    
    return header + '\n'.join(result)

# Language-specific content injection
def get_language_standards() -> str:
    """Read and combine all language standards."""
    lang_dir = INSTRUCTIONS_DIR / "languages"
    if not lang_dir.exists():
        return ""
    
    content = ["\n# LANGUAGE-SPECIFIC STANDARDS\n"]
    for lang_file in sorted(lang_dir.glob("*.md")):
        content.append(f"\n## {lang_file.stem.upper()}\n")
        content.append(lang_file.read_text(encoding='utf-8'))
    
    return '\n'.join(content)

# Main generation functions
def generate_codex() -> str:
    """Generate Codex instructions."""
    core = read_all_core()
    # For now, use core content only (language standards can be added later)
    return to_codex_format(core)

def generate_claude() -> str:
    """Generate Claude Code CLAUDE.md."""
    core = read_all_core()
    return to_claude_format(core)

def generate_cursor() -> str:
    """Generate Cursor .cursorrules."""
    core = read_all_core()
    return to_cursor_format(core)

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
    
    print("\n" + "=" * 60)
    print("Generation Complete!")
    print("=" * 60)
    print("\nGenerated files:")
    print("  - codex/instructions.md")
    print("  - claude/CLAUDE.md")
    print("  - cursor/.cursorrules")
    print("  - en/codex/instructions.md (CN)")
    print("  - en/claude/CLAUDE.md (CN)")
    print("  - en/cursor/.cursorrules (CN)")
    print("\nNote: Chinese translations are placeholders.")
    print("      Run with LLM API integration for actual translation.")

if __name__ == "__main__":
    main()
