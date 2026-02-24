# frozen_string_literal: true

class TableOfContentsGenerator
  class << self
    def generate(categories)
      return '' if categories.nil? || categories.empty?

      lines = ["## Table of Contents\n"]

      categories.each do |category_name|
        slug = slugify(category_name)
        lines << "- [#{category_name}](##{slug})"
      end

      lines.join("\n") + "\n"
    end

    def slugify(text)
      text
        .downcase
        .gsub(/[^\w\s-]/, '') # Remove special characters except spaces and hyphens
        .gsub(/\s/, '-')       # Replace each space with a hyphen (preserves consecutive)
    end
  end
end
