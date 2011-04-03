#encoding: utf-8
require "utils"

namespace :db do
  namespace :populate do
    desc "Populate departments, employees and generate (randomly) timesheet data"
    task(:all => ["db:populate:departments", "db:populate:employees", "db:populate:timesheets"])

    desc "Generate (randomly) timesheet data"
    task(:timesheets => ["db:populate:timeevents"])

    desc "Populate permanent departments"
    task :departments => :environment do
      puts "\n" + "** ".bold + "Создаем департаменты...".green.bold
      departments = ["Дирекция", "Юридический отдел", "Финансовый отдел", "Маркетинговый отдел", "Техническая поддержка", "Инженерный отдел", "Рабочие"]
      ActiveRecord::Base.transaction do
        Department.delete_all
        departments.each do |departmen|
          Department.create(:name => departmen)
          puts "    -->".bold + "  создан  ".green + departmen
        end
      end
    end

    desc "Populate employees"
    task :employees => :environment do
      puts "\n" + "** ".bold + "Парсим депутатов госдумы РФ - пусть поработают хотя бы виртуально ;)\n".green.bold
      names = []
      wiki_urls = ['http://ru.wikipedia.org/wiki/%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA_%D0%B4%D0%B5%D0%BF%D1%83%D1%82%D0%B0%D1%82%D0%BE%D0%B2_%D0%93%D0%BE%D1%81%D1%83%D0%B4%D0%B0%D1%80%D1%81%D1%82%D0%B2%D0%B5%D0%BD%D0%BD%D0%BE%D0%B9_%D0%B4%D1%83%D0%BC%D1%8B_%D0%A0%D0%BE%D1%81%D1%81%D0%B8%D0%B9%D1%81%D0%BA%D0%BE%D0%B9_%D0%A4%D0%B5%D0%B4%D0%B5%D1%80%D0%B0%D1%86%D0%B8%D0%B8_I_%D1%81%D0%BE%D0%B7%D1%8B%D0%B2%D0%B0',
      'http://ru.wikipedia.org/wiki/%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA_%D0%B4%D0%B5%D0%BF%D1%83%D1%82%D0%B0%D1%82%D0%BE%D0%B2_%D0%93%D0%BE%D1%81%D1%83%D0%B4%D0%B0%D1%80%D1%81%D1%82%D0%B2%D0%B5%D0%BD%D0%BD%D0%BE%D0%B9_%D0%B4%D1%83%D0%BC%D1%8B_%D0%A0%D0%BE%D1%81%D1%81%D0%B8%D0%B9%D1%81%D0%BA%D0%BE%D0%B9_%D0%A4%D0%B5%D0%B4%D0%B5%D1%80%D0%B0%D1%86%D0%B8%D0%B8_II_%D1%81%D0%BE%D0%B7%D1%8B%D0%B2%D0%B0',
      'http://ru.wikipedia.org/wiki/%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA_%D0%B4%D0%B5%D0%BF%D1%83%D1%82%D0%B0%D1%82%D0%BE%D0%B2_%D0%93%D0%BE%D1%81%D1%83%D0%B4%D0%B0%D1%80%D1%81%D1%82%D0%B2%D0%B5%D0%BD%D0%BD%D0%BE%D0%B9_%D0%B4%D1%83%D0%BC%D1%8B_%D0%A0%D0%BE%D1%81%D1%81%D0%B8%D0%B9%D1%81%D0%BA%D0%BE%D0%B9_%D0%A4%D0%B5%D0%B4%D0%B5%D1%80%D0%B0%D1%86%D0%B8%D0%B8_III_%D1%81%D0%BE%D0%B7%D1%8B%D0%B2%D0%B0',
      'http://ru.wikipedia.org/wiki/%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA_%D0%B4%D0%B5%D0%BF%D1%83%D1%82%D0%B0%D1%82%D0%BE%D0%B2_%D0%93%D0%BE%D1%81%D1%83%D0%B4%D0%B0%D1%80%D1%81%D1%82%D0%B2%D0%B5%D0%BD%D0%BD%D0%BE%D0%B9_%D0%B4%D1%83%D0%BC%D1%8B_%D0%A0%D0%BE%D1%81%D1%81%D0%B8%D0%B9%D1%81%D0%BA%D0%BE%D0%B9_%D0%A4%D0%B5%D0%B4%D0%B5%D1%80%D0%B0%D1%86%D0%B8%D0%B8_IV_%D1%81%D0%BE%D0%B7%D1%8B%D0%B2%D0%B0',
      'http://ru.wikipedia.org/wiki/%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA_%D0%B4%D0%B5%D0%BF%D1%83%D1%82%D0%B0%D1%82%D0%BE%D0%B2_%D0%93%D0%BE%D1%81%D1%83%D0%B4%D0%B0%D1%80%D1%81%D1%82%D0%B2%D0%B5%D0%BD%D0%BD%D0%BE%D0%B9_%D0%B4%D1%83%D0%BC%D1%8B_%D0%A0%D0%BE%D1%81%D1%81%D0%B8%D0%B9%D1%81%D0%BA%D0%BE%D0%B9_%D0%A4%D0%B5%D0%B4%D0%B5%D1%80%D0%B0%D1%86%D0%B8%D0%B8_V_%D1%81%D0%BE%D0%B7%D1%8B%D0%B2%D0%B0']

      wiki_urls.each { |wiki_url| names << TimeControl::Utils::Parser.instance.parse_wiki_deputats(wiki_url) }

      departments = Department.all

      ActiveRecord::Base.transaction do
        Employee.delete_all
        names.flatten.uniq.sort.each do |name|
          index = Random.new.rand(0..departments.count-1)
          Employee.create(:name => name, :department => departments[index])
          puts "    -->".bold + "  добавлен  ".green + name
          puts "    -->".bold + "  " + departments[index].name.yellow
        end
      end

      puts "    -->".bold + "  Добавлено депутатов: ".green + Employee.count.to_s.bold

    end

    desc "Generate (randomly) timeevents data"
    task :timeevents => :environment do
      puts "\n" + "** ".bold + "Генерируем данные о доступе за последние два года...\n".green.bold

      start_work = 8.hour
      end_work = 18.hour
      now = Time.now.to_date

      TimeEvent.delete_all

      Employee.all.each do |employee|
        puts "    -->".bold + "  генерируем для  ".green + employee.name
        ActiveRecord::Base.transaction do
          (now-2.month..now).to_a.each do |current_day|
            timesheet_by_date = TimesheetByDay.create(:employee_id => employee.id, :day => current_day)
            if !current_day.saturday? && !current_day.sunday? && Random.new.rand(1..100) < 98
              current_time = current_day + 7.hour + 20.minute
              while current_time < (current_day + end_work) do
                current_time += Random.new.rand(30..90).minute
                TimeEvent.create(:employee_id => employee.id, :event_time => current_time, :event_type => TimeEvent::IN, :timesheet_by_day_id => timesheet_by_date.id)
                out_inc = Random.new.rand(180..240).minute
                if current_time + out_inc > (current_day + end_work)
                  current_time +=  Random.new.rand(30..60).minute
                else
                  current_time += out_inc
                end
                TimeEvent.create(:employee_id => employee.id, :event_time => current_time, :event_type => TimeEvent::OUT, :timesheet_by_day_id => timesheet_by_date.id)
              end

              timesheet_by_date.no_work = false

              time_events = timesheet_by_date.time_events.order('event_time').all
              timesheet_by_date.start_time = time_events.first.event_time
              timesheet_by_date.end_time = time_events.last.event_time

              start_delta = (current_day + start_work) - time_events.first.event_time

              if start_delta < 0
                timesheet_by_date.has_late = true
                timesheet_by_date.late_value = (-start_delta.to_i)/60
              end

              time_events.each_slice(2) do |period|
                timesheet_by_date.work_time += (period.last.event_time - period.first.event_time).to_i / 60
              end

              timesheet_by_date.save
            end
          end
        end
      end
    end
  end
end
