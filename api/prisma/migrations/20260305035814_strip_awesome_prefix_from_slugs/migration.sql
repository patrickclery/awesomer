-- Strip "awesome-" prefix from AwesomeList slugs (except the meta-list "awesome")
UPDATE awesome_lists
SET slug = REGEXP_REPLACE(slug, '^awesome-', '')
WHERE slug LIKE 'awesome-%';
