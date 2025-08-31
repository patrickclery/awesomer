#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'config/environment'

# List of repositories that failed to generate git stars (from our previous analysis)
# These were the 146 repositories that showed "N/A" values
failed_repos = [
  '0xnr/awesome-analytics',
  '0xnr/awesome-bigdata',
  'APA-Technology-Division/urban-and-regional-planning-resources',
  'AdrienTorris/awesome-blazor',
  'Anant/awesome-cassandra',
  'AppImage/awesome-appimage',
  'CUTR-at-USF/awesome-transit',
  'CodyReichert/awesome-cl',
  'DanailMinchev/awesome-eosio',
  'Dvergar/awesome-haxe-gamedev',
  'Esri/awesome-arcgis-developer',
  'Friz-zy/awesome-linux-containers',
  'Granze/awesome-polymer',
  'JStumpp/awesome-android',
  'Karneades/awesome-malware-persistence',
  'Kikobeats/awesome-network-js',
  'LewisJEllis/awesome-lua',
  'LucasBassetti/awesome-less',
  'MartinMiles/awesome-sitecore',
  'MunGell/awesome-for-beginners',
  'PatrickJS/awesome-angular',
  'Solido/awesome-flutter',
  'agarrharr/awesome-macos-screensavers',
  'alebcay/awesome-shell',
  'alexanderisora/awesome-entertainment',
  'andrewngu/awesome-dotnet',
  'angrykoala/awesome-esolangs',
  'bnb/awesome-hyper',
  'briatte/awesome-network-analysis',
  'brunopulis/awesome-a11y',
  'burningtree/awesome-json',
  'caesar0301/awesome-pcaptools',
  'captn3m0/awesome-vcs',
  'carpedm20/awesome-hacking',
  'chentsulin/awesome-graphql',
  'chubin/awesome-console-services',
  'clkao/awesome-dat',
  'coopermaa/awesome-sinatra',
  'crisxuan/awesome-programming-books',
  'cristianoliveira/awesome-functional-programming',
  'dhamaniasad/awesome-postgres',
  'diessica/awesome-sketch',
  'donnemartin/awesome-aws',
  'dreispt/awesome-odoo',
  'ekremkaraca/awesome-rails',
  'emijrp/awesome-awesome',
  'enocom/gopher-reading-list',
  'epoyraz/awesome-pharo',
  'fasouto/awesome-dataviz',
  'fffaraz/awesome-cpp',
  'fr33co/awesome-ionic',
  'gdi2290/awesome-angular',
  'h4cc/awesome-elixir',
  'hachiojipm/awesome-perl',
  'hkirat/awesome-chess',
  'hslatman/awesome-threat-intelligence',
  'humiaozuzu/awesome-flask',
  'iCHAIT/awesome-macOS',
  'icepy/Front-End-Develop-Guide',
  'igorbarinov/awesome-bitcoin',
  'imbaniac/awesome-blockchain',
  'jaredpalmer/awesome-react-render-props',
  'jbhuang0604/awesome-computer-vision',
  'jekyll/awesome-jekyll',
  'josephmisiti/awesome-machine-learning',
  'k4m4/movies-for-hackers',
  'karan/Projects',
  'keon/awesome-nlp',
  'klaussinani/awesome-vapor',
  'kud1ing/awesome-rust',
  'ligurio/awesome-software-quality',
  'lk-geimfari/awesome-cryptography',
  'mailtoharshit/awesome-salesforce',
  'mark-rushakoff/awesome-influxdb',
  'matteofigus/awesome-speaking',
  'maximAbramchuck/awesome-interview-questions',
  'mcxiaoke/awesome-kotlin',
  'meirwah/awesome-incident-response',
  'neutraltone/awesome-stock-resources',
  'ossu/computer-science',
  'paulmillr/es6-shim',
  'pawl/awesome-etl',
  'pFarb/awesome-crypto-papers',
  'posquit0/Awesome-CV',
  'prahladyeri/CuratedLists',
  'qinwf/awesome-R',
  'RichardLitt/awesome-styleguides',
  'ritchieng/the-incredible-pytorch',
  'rosarior/awesome-django',
  'rust-unofficial/awesome-rust',
  'sanketfirodiya/sample-watchkit-apps',
  'sellmerfud/awesome-elm',
  'serhii-londar/open-source-mac-os-apps',
  'SrTobi/awesome-scala',
  'stevemao/awesome-git-addons',
  'stoeffel/awesome-fp-js',
  'stuartlangridge/awesome-devenv',
  'therebelrobot/awesome-bootstrap',
  'tildeio/rsvp.js',
  'tuvtran/project-based-learning',
  'ujjwalkarn/Machine-Learning-Tutorials',
  'unixorn/awesome-zsh-plugins',
  'viatsko/awesome-vscode',
  'vininjr/awesome-ionic',
  'wbinnssmith/awesome-promises',
  'wesbos/awesome-uses',
  'xiaohanyu/awesome-tikz',
  'youngwookim/awesome-hadoop',
  'ziadoz/awesome-php'
]

puts "🚀 Processing #{failed_repos.length} repositories that failed to generate git stars..."
puts 'Output will be saved to static/md/ directory'
puts 'Using improved logic that:'
puts '  ✅ Filters out 404 repositories completely'
puts '  ✅ Only includes GitHub repositories'
puts '  ✅ Removes all markdown links from descriptions'
puts ''

# Ensure output directory exists
system('mkdir -p static/md')

failed_count = 0
success_count = 0

# Process in smaller batches to avoid overwhelming the system
batch_size = 10
total_batches = (failed_repos.length.to_f / batch_size).ceil

failed_repos.each_slice(batch_size).with_index do |batch, batch_index|
  puts "📦 Processing batch #{batch_index + 1}/#{total_batches} (#{batch.length} repos)..."

  batch.each_with_index do |repo, index|
    overall_index = (batch_index * batch_size) + index + 1

    puts "  [#{overall_index}/#{failed_repos.length}] Processing #{repo}..."

    begin
      # Run the CLI command
      result = system("bundle exec ruby lib/cli/markdown_processor.rb process_repo \"#{repo}\" " \
                      '--output-dir "static/md" --sync > /dev/null 2>&1')

      if result
        success_count += 1
        puts '    ✅ Success'
      else
        failed_count += 1
        puts '    ❌ Failed'
      end
    rescue StandardError => e
      failed_count += 1
      puts "    ❌ Error: #{e.message}"
    end

    # Small delay to be nice to GitHub API
    sleep(0.5) if overall_index % 5 == 0
  end

  puts "  Batch #{batch_index + 1} completed. Success: #{success_count}, Failed: #{failed_count}"
  puts ''
end

puts '🎉 Processing completed!'
puts '📊 Final Results:'
puts "  ✅ Successfully processed: #{success_count}"
puts "  ❌ Failed: #{failed_count}"
puts '  📁 Output files in: static/md/'
puts ''

# List generated files
generated_files = Dir.glob('static/md/*.md')
puts "📄 Generated #{generated_files.length} markdown files:"
generated_files.each { |file| puts "  - #{File.basename(file)}" }
