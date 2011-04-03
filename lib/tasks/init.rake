#encoding: utf-8
namespace :db do
  # TODO. Сменить описание
  desc "Populate departments, employees and generate (randomly) timesheet data"
  task(:init => ["db:schema:load", "db:populate:all"])
end
