#encoding: utf-8
namespace :db do
  desc "Init database from a scratch. Load schema, populate departments, employees and generate (randomly) timesheet data"
  task(:init => ["db:schema:load", "db:populate:all"])
end
