import { getParser } from '../parser-factory.js';
import { DefaultReadmeParser } from '../default-readme-parser.js';
import { AiAgentsReadmeParser } from '../ai-agents-readme-parser.js';
import { OpensourceAiReadmeParser } from '../opensource-ai-readme-parser.js';
import { McpServersReadmeParser } from '../mcp-servers-readme-parser.js';

describe('getParser', () => {
  it('returns DefaultReadmeParser for null', () => {
    expect(getParser(null)).toBeInstanceOf(DefaultReadmeParser);
  });

  it('returns DefaultReadmeParser for undefined', () => {
    expect(getParser(undefined)).toBeInstanceOf(DefaultReadmeParser);
  });

  it('returns DefaultReadmeParser for unknown parserType', () => {
    expect(getParser('unknown-type')).toBeInstanceOf(DefaultReadmeParser);
  });

  it('returns AiAgentsReadmeParser for "ai-agents"', () => {
    expect(getParser('ai-agents')).toBeInstanceOf(AiAgentsReadmeParser);
  });

  it('returns OpensourceAiReadmeParser for "opensource-ai"', () => {
    expect(getParser('opensource-ai')).toBeInstanceOf(OpensourceAiReadmeParser);
  });

  it('returns McpServersReadmeParser for "mcp-servers"', () => {
    expect(getParser('mcp-servers')).toBeInstanceOf(McpServersReadmeParser);
  });
});
