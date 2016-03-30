#!/usr/bin/env ruby
# coding: utf-8

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'twitter'

page = Nokogiri::HTML(open("http://cwb.gov.tw/m/eq/recent.htm"))
eq_url_id_item = page.xpath('//table//tr//@va') #搜尋table裡的tr裡所有屬性為va的值，以獲取URL
eq_class_item = page.xpath('//table//tr//td')
eq_time_item = page.xpath("//table//tr//td/following-sibling::td[1]")
eq_mq_item = page.xpath("//table//tr//td/following-sibling::td[2]")
eq_deep_item = page.xpath("//table//tr//td/following-sibling::td[3]")
eq_loc_item = page.xpath("//table//tr//td/following-sibling::td[4]")


eq_class = String(eq_class_item[0]).strip
puts eq_class

eq_time = String(eq_time_item[0]).strip
puts eq_time

eq_mq = String(eq_mq_item[0]).strip
puts eq_mq

eq_deep = String(eq_deep_item[0]).strip
puts eq_deep

eq_loc = String(eq_loc_item[0]).strip.delete(" ")
puts eq_loc

def build_eq_text(cl=eq_class, time=eq_time, mq=eq_mq, deep=eq_deep, link=eq_link, loc=eq_loc)
	eq_text = cl + " " + time + " " + loc +  " 規模" + mq + " 深度" + deep + "KM " + link + " #earthquake #地震"
	return eq_text
end

def parse_url_id(item=eq_url_id_item)
	lastest_id = String(item[0])
	urlid = lastest_id.split('/')
	return String(urlid[1])
end

current_eq_id = parse_url_id(eq_url_id_item)

eq_link = "http://www.cwb.gov.tw/m/eq/recent.htm?LINE=" + current_eq_id
# puts eq_link

filename = "/home/justin/earthquake_tw_ruby/eq_id.log"
eq_id_log_file = File.open(filename, 'r')
# puts "Here's EQ ID log file: #{filename}"
prev_eq_id = eq_id_log_file.read()
# puts "--------"
# puts prev_eq_id
# puts current_eq_id
# puts "--------"
eq_id_log_file.close()

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ""
  config.consumer_secret     = ""
  config.access_token        = ""
  config.access_token_secret = ""
end

if prev_eq_id == current_eq_id

else
	target = File.open(filename, 'w')
	target.write(current_eq_id)
	puts "Save " + current_eq_id + " to " + filename
	target.close()	

	
	tweet_text = build_eq_text(eq_class, eq_time, eq_mq, eq_deep, eq_link, eq_loc)
	client.update(tweet_text)
	puts tweet_text
end





