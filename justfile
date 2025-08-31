# Default recipe
default:
    @just --list

# Format YAML files with Prettier
format-yaml:
    @echo "🔧 Formatting YAML files with Prettier..."
    npx prettier --write "**/*.{yml,yaml}"

# Sort YAML files alphabetically with yq
sort-yaml:
    @echo "📝 Sorting YAML files alphabetically with yq..."
    @for file in $(find . -name "*.yml" -o -name "*.yaml" | grep -v node_modules | grep -v vendor); do \
        if [[ -f "$$file" ]]; then \
            echo "  Sorting $$file..."; \
            cp "$$file" "$$file.tmp"; \
            yq e 'sort_keys(.)' "$$file.tmp" > "$$file"; \
            rm "$$file.tmp"; \
        fi; \
    done

# Lint YAML files with yamllint
lint-yaml:
    @echo "✅ Running yamllint to check for issues..."
    yamllint .

# Format, sort, and lint all YAML files
yaml: format-yaml sort-yaml lint-yaml
    @echo "🎉 All YAML files are properly formatted, sorted, and linted!"

# Format Markdown files with Prettier
format-markdown-prettier:
    @echo "📝 Formatting Markdown files with Prettier..."
    npx prettier --write "**/*.md"

# Format Markdown tables with proper alignment (without Prettier)
format-markdown:
    @echo "📊 Formatting Markdown tables with proper alignment..."
    @for file in $(find . -name "*.md" -not -path "./node_modules/*" -not -path "./vendor/*"); do \
        npx markdown-table-prettify "$$file" || true; \
    done

# Format Markdown files with Prettier and then tables (use if you want both)
format-markdown-full: format-markdown-prettier format-markdown
    @echo "✨ Markdown files and tables are properly formatted!"

# Format all files (YAML and Markdown)
format-all: format-yaml format-markdown-full
    @echo "✨ All files are properly formatted!"

# Run all tests
test:
    bundle exec rspec

# Run RuboCop
rubocop:
    bundle exec rubocop

# Lint Ruby files with RuboCop (with auto-correct)
lint-ruby:
    @echo "🔍 Linting and fixing Ruby files with RuboCop..."
    bundle exec rubocop --parallel -A

# Lint and format Markdown files with Prettier and table formatter
lint-markdown:
    @echo "🔍 Linting and formatting Markdown files..."
    npx prettier --write "**/*.md"
    @echo "📊 Formatting tables..."
    @for file in $(find . -name "*.md" -not -path "./node_modules/*" -not -path "./vendor/*"); do \
        npx markdown-table-prettify "$$file" || true; \
    done

# Lint and format YAML/JSON files with Prettier
lint-config:
    @echo "🔍 Linting and formatting YAML/JSON files..."
    npx prettier --write "**/*.{yml,yaml,json}"

# Run all linting checks (no fixes) - continues on error
lint:
    @echo "🔍 Running all linting checks..."
    -@just lint-ruby
    -@just lint-yaml
    -@just lint-markdown
    -@just lint-config
    @echo "✅ All linting checks completed!"

# Run all quality checks
qa: test rubocop yaml
    @echo "🚀 All quality checks passed!"