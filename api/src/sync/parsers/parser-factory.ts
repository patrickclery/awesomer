import type { ReadmeParser } from './readme-parser.interface.js';
import { DefaultReadmeParser } from './default-readme-parser.js';
import { AiAgentsReadmeParser } from './ai-agents-readme-parser.js';
import { OpensourceAiReadmeParser } from './opensource-ai-readme-parser.js';
import { McpServersReadmeParser } from './mcp-servers-readme-parser.js';

export function getParser(parserType: string | null | undefined): ReadmeParser {
  switch (parserType) {
    case 'ai-agents':
      return new AiAgentsReadmeParser();
    case 'opensource-ai':
      return new OpensourceAiReadmeParser();
    case 'mcp-servers':
      return new McpServersReadmeParser();
    default:
      return new DefaultReadmeParser();
  }
}
