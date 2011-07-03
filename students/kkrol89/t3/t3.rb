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
  def to_html
  end
end

get "/" do
end

get "/node/:id" do
  node = Node.find(params[:id])
  NodeView.new(node).to_html
end
