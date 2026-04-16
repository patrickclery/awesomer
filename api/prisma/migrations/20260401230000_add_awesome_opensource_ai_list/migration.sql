-- Insert awesome-opensource-ai as a new awesome list vertical
INSERT INTO awesome_lists (name, slug, description, github_repo, state, skip_external_links, sort_preference, parser_type, theme, created_at, updated_at)
VALUES (
  'Awesome Open Source AI',
  'opensource-ai',
  'A comprehensive list of open-source AI tools, frameworks, and models',
  'alvinreal/awesome-opensource-ai',
  'pending',
  true,
  'stars',
  'opensource-ai',
  'claude',
  NOW(),
  NOW()
);
