export interface ParsedItem {
  name: string;
  primaryUrl: string;
  githubRepo: string | null;
  description: string | null;
  categoryIndex: number;
}

export interface ParsedCategory {
  name: string;
  order: number;
}

export interface ParseResult {
  categories: ParsedCategory[];
  items: ParsedItem[];
}

export interface ReadmeParser {
  /** Repo-relative path parsed instead of the README; `undefined` means use the README. */
  readonly sourcePath?: string;
  parse(content: string): ParseResult;
}
