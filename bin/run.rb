#!/usr/bin/env ruby

$:.push File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'NonogramSolver'

ns = NonogramSolver.new
ns.main
