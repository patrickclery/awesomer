import type { ReadmeParser } from './readme-parser.interface.js';
import { DefaultReadmeParser } from './default-readme-parser.js';
import { AiAgentsReadmeParser } from './ai-agents-readme-parser.js';
import { OpensourceAiReadmeParser } from './opensource-ai-readme-parser.js';
import { McpServersReadmeParser } from './mcp-servers-readme-parser.js';
import { ImmichItemsJsonParser } from './immich-items-json-parser.js';

/**
 * Every parserType getParser() recognizes. 'default' names the fallback parser used for
 * a null or unknown value, so tools can reject a typo instead of silently falling back.
 */
export const PARSER_TYPES = ['default', 'ai-agents', 'opensource-ai', 'mcp-servers', 'immich'] as const;

export function getParser(parserType: string | null | undefined): ReadmeParser {
  switch (parserType) {
    case 'ai-agents':
      return new AiAgentsReadmeParser();
    case 'opensource-ai':
      return new OpensourceAiReadmeParser();
    case 'mcp-servers':
      return new McpServersReadmeParser();
    case 'immich':
      return new ImmichItemsJsonParser();
    default:
      return new DefaultReadmeParser();
  }
}
