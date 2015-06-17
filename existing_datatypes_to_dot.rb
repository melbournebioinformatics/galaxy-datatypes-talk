#!/usr/bin/env ruby

require 'libxml'
require 'graphviz'

include LibXML

doc = XML::Parser.file("#{ARGV[0]}").parse

g = GraphViz.new( :G, :type => :digraph )

parent_nodes = {}

subtype_nodes = {}

doc.find("//datatype").each do |datatype|  

	type_spec = datatype.attributes['type']

	parent = type_spec.match(/galaxy.datatypes.([^\:]*)/).captures.first
	subtype = type_spec.match(/galaxy.datatypes.([^\:]*):(.*)/).captures.last

	extension = datatype.attributes['extension']

	if !parent_nodes[parent]
		parent_nodes[parent] = g.add_nodes(parent)
	end

	if !subtype_nodes[subtype]
		subtype_nodes[subtype] = g.add_nodes(subtype)
		g.add_edge(parent_nodes[parent],subtype_nodes[subtype])		
	end

	# require 'byebug';byebug

	extnode=g.add_nodes(extension)
	g.add_edge(subtype_nodes[subtype],extnode)

	# parent_nodes[parent].add_nodes(subtype)

end

puts g.to_s