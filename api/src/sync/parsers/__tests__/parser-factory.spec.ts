import { getParser, PARSER_TYPES } from '../parser-factory.js';
import { DefaultReadmeParser } from '../default-readme-parser.js';
import { AiAgentsReadmeParser } from '../ai-agents-readme-parser.js';
import { OpensourceAiReadmeParser } from '../opensource-ai-readme-parser.js';
import { McpServersReadmeParser } from '../mcp-servers-readme-parser.js';
import { ImmichItemsJsonParser } from '../immich-items-json-parser.js';

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

  it('maps every non-default PARSER_TYPES entry to its own parser', () => {
    for (const type of PARSER_TYPES) {
      if (type === 'default') continue;
      expect(getParser(type)).not.toBeInstanceOf(DefaultReadmeParser);
    }
  });

  it('returns ImmichItemsJsonParser for "immich"', () => {
    const parser = getParser('immich');
    expect(parser).toBeInstanceOf(ImmichItemsJsonParser);
    expect(parser.sourcePath).toBe('apps/awesome.immich.app/src/data/items.json');
  });
});
