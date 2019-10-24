namespace :brexit_checker do
  namespace :link_monitor do
    desc "Import actions CSV and convert to YAML file"
    task check_action_links: :environment do
      monitor = BrexitChecker::LinkMonitor.new
      monitor.call
    end
  end
end
