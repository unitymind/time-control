#encoding: utf-8
require "yajl"
class ReportController < ApplicationController
  autocomplete :employee, :name, :filter_by => :by_department, :limit => 1600

  def filter
    @result = []
    @is_personal = false
    @department_name = "Все отделы"
    unless params[:period_from].to_date.nil? || params[:period_to].to_date.nil?
      period = params[:period_from].to_date..params[:period_to].to_date

      unless params[:employee_id].blank?
        @result = to_personal_json(TimesheetByDay.where(:day => period, :employee_id => params[:employee_id]).order('day').all)
        @employee_name = Employee.find(params[:employee_id]).name
        @is_personal = true
      else
        late_rel = TimesheetByDay.where(:day => period, :has_late => true)
        work_rel = TimesheetByDay.where(:day => period, :no_work => false)

        unless params[:department_id].blank?
          ids = Employee.where(:department_id => params[:department_id]).select('id').all.map { |m| m.id }
          late_rel = late_rel.where(:employee_id => ids)
          work_rel = work_rel.where(:employee_id => ids)
          @department_name = Department.find(params[:department_id]).name
        end

        result = {}
        period.to_a.each { |day| result[day] = {} }

        late_rel.group(:day).count.each { |day, count| result[day.to_date][:late_count] = count }
        late_rel.group(:day).average(:late_value).each { |day, value| result[day.to_date][:late_value] = value.to_f.round(2) }
        work_rel.group(:day).count.each { |day, count| result[day.to_date][:work_count] = count }
        work_rel.group(:day).average(:work_time).each { |day, value| result[day.to_date][:work_time] = value.to_f.round(2) }

        @result = to_common_json(result)
      end
    end
  end

  private
    def to_personal_json(items)
      items.collect { |item| [item.day, item.start_time.nil? ? 'Не работал' : item.start_time.strftime('%H:%M'), item.end_time.nil? ? 'Не работал' : item.end_time.strftime('%H:%M'), "#{item.work_time / 60}:#{sprintf("%02d", item.work_time % 60)}", item.has_late, item.late_value] }
    end

    def to_common_json(items)
      result = []
      items.each do |day, data|
        unless data.empty?
          result.push [day, data[:late_count], data[:late_value].to_i, data[:work_count], "#{data[:work_time].to_i / 60}:#{sprintf("%02d", data[:work_time].to_i % 60)}"]
        end
      end
      result
    end
end
