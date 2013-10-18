desc 'Run all deployment rake tasks'
task :post_deploy => ['deploy:migrate_db', 'deploy:precompile_assets', 'deploy:tell_newrelic', 'deploy:restart_app']
