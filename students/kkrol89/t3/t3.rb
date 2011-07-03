#!/usr/bin/env ruby

# Install Sinatra framework:
#     sudo gem install sinatra
#
# Documentation: 
#  * http://www.sinatrarb.com/
#  * http://railsapi.com/doc/sinatra-v1.0/
#
# Simple labyrinth game implemented as web application running at http://localhost:4567/
#
# Starting on a home page it presents user with a short description of his 
# locations and available paths he can take (as links).
#
# When gamer gets to last location he is presented with a "YOU'RE WINNER !" 
# congratulations text.
#

require 'rubygems'
require 'sinatra'

class Node
  @@nodes = Array.new #class variable
  
  def initialize(title, text)
    @title = title
    @text = text
    
    @id = @@nodes.size+1 #simple id generator
    
    @exits = Hash.new
    
    @@nodes << self
  end
  
  def self.reset
    @@nodes.clear
  end
  
  def self.add_node(node)
  end
  
  def self.find(id)
    id = id.to_i unless id.kind_of? Fixnum
    @@nodes.each do |node|
      return node if node.id==id
    end
  end
  
  attr_accessor :id
  attr_accessor :title
  attr_accessor :text
  attr_accessor :exits
  
  def add_exit(text, node)
    @exits[text] = node
  end
  
  def finish?
    exits.empty?
  end
end

class NodeView
  def initialize(node)
    @node = node
  end
  
  def to_html
        %Q[<html>
<head>
  <title>#{@node.title}</title>
</head>
<body>
  <h1>#{@node.id}</h1>
  <h1>#{@node.title}</h1>
  <p>#{@node.text}</p> <br />
  #{connected_nodes_to_html @node}
</body>
    ]
  end
  
  def connected_nodes_to_html(node)
    if node.finish?
      "<p>YOU ARE WINNER !</p>"
    else
      "<ul>" + node.exits.map { |direction, neighbour| "<li><a href=\"/node/#{neighbour.id}\">#{direction}</a></li>" }.join(" ") + "</ul>"
    end
  end
end


#--- initialization ---
Node.reset
@start = Node.new("Start", "Start node")
@finish = Node.new("Finish", "Finish node")
@finish2 = Node.new("Finish2", "Second finish node")
@start.add_exit "forward", @finish
@start.add_exit "left", @finish2
#--- end ---

get "/" do
  "Welcome to labyrinth"
end

get "/node/:id" do
  node = Node.find(params[:id])
  NodeView.new(node).to_html
end
