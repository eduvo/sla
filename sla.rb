#!/usr/bin/env ruby

require 'rubygems'
require 'active_support'
require 'basecamp'
require 'colorize'
require 'optparse'
require 'terminal-table'
require 'pp'

options = OpenStruct.new(endpoint: nil, api_key: nil, project_id: nil).tap { |options|
  options.endpoint = 'eduvo.basecamphq.com'
  
  parser = OptionParser.new { |opts|
    opts.banner = "Usage: sla.rb [options]"
    opts.on('--endpoint ENDPOINT', 'Basecamp Endpoint', "Default: #{options.endpoint}") { |x| options.endpoint = x }
    opts.on('--key API_KEY', 'Basecamp API Key', 'See: https://zapier.com/help/basecamp-classic#how-get-started-basecamp-classic') { |x| options.api_key = x }
    opts.on('--project PROJECT_ID', 'Basecamp Project ID') { |x| options.project_id = x }
  }
  
  parser.parse!(ARGV)
  
  if %i(api_key endpoint project_id).any? { |x| options.send(x).nil? }
    puts parser
    exit 1
  end
}

Basecamp.establish_connection!(options.endpoint, options.api_key, 'X', true)

# Finalsite Apply
Basecamp::TodoList.all(options.project_id, false).sort_by(&:position).each { |list|
  items = list.todo_items.sort_by(&:position).find_all { |x| !(x.completed) }
  next unless items.size > 0
  headers = [
    'Item',
    'Creator',
    'Created At',
    'SLA (h)',
    'SLA (%)'
  ]
  
  table = Terminal::Table.new(title: list.name, headings: headers) do |table|
    items.each { |item|
      hours = ((Time.now - item.created_on) / 1.hour).round(1)
      
      wrap = if hours > 48
        -> (x) { x.colorize(:light_red) }
      elsif hours > 24
        -> (x) { x.colorize(:magenta) }
      else
        -> (x) { x.colorize(:light_green) }
      end
      
      table << [
        wrap.(item.content[0..40]),
        wrap.(item.creator_name),
        wrap.(item.created_on.strftime('%b %-d, %Y')),
        wrap.("#{hours}h"),
        wrap.("#{((hours / 24) * 100).round(2)}%")
      ]
    }
  end
  
  puts table
  puts ""
}
