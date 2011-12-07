require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'awesome_print'

require './kindle-daily-deal'

run KindleDailyDeal