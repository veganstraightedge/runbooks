#!/usr/bin/env ruby
require 'runbook'

runbook = Runbook.book 'Fix Postgres' do
  description 'This runbook is for when postgres doesn’t seem to be working'

  section 'Check Postgres is installed' do
    step 'Set Postgres version' do
      ask "What version of Postgres do you want to fix? (9.4 9.5 9.6 10 11 12 13 14 15/latest)", into: :greatest, default: "15"

      ruby_command { note "Postgres version set to: #{@greatest}" }
    end

    step 'Check brew installation' do
      command %q{brew info postgresql | grep 'installed'}

      note 'brew info postgresql'
    end

    step 'Check psql version' do
      note 'psql --version'
    end

    step 'Check psql location' do
      note 'which psql'
    end
  end

  section 'Check postgres is running' do
    step 'Check brew services' do
      note 'brew services list'
      note 'Does it say ‘started’ in yellow?'
    end

    step 'Check postgres is ready' do
      note 'pg_isready'
    end
  end

  section 'Is postmaster.pid the culprit?' do
    step 'Check for postmaster.pid' do
      note 'cat /usr/local/var/postgresql/postmaster.pid'
      note 'cat /usr/local/var/postgres/postmaster.pid'
      note 'cat /opt/homebrew/var/postgres/postmaster.pid'
      note 'cat /opt/homebrew/var/postgresql@15/postmaster.pid'
    end

    step 'Delete postmaster.pid' do
      note 'rm /usr/local/var/postgresql/postmaster.pid'
      note 'rm /usr/local/var/postgres/postmaster.pid'
      note 'rm /opt/homebrew/var/postgres/postmaster.pid'
      note 'rm /opt/homebrew/var/postgresql@15/postmaster.pid'
    end

    step 'Check brew services again' do
      note 'brew services list'
    end

    step 'Restart postgres' do
      note 'brew services restart postgresql'
    end

    step 'Double confirmation' do
      note 'brew services list'
      note 'pg_isready'
    end
  end
end

if __FILE__ == $0
  Runbook::Runner.new(runbook).run
else
  runbook
end
